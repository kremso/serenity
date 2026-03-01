require 'zip'
require 'fileutils'

module Serenity
  class Template
    attr_accessor :template

    def initialize(template, output)
      FileUtils.cp(template, output)
      @template = output
    end

    def process context
      tmpfiles = []
      Zip::File.open(@template) do |zipfile|
        # Pre-read embedded object templates for inline processing
        object_entries = zipfile.entries
          .map(&:name)
          .select { |name| name.match?(%r{\AObject \d+/(content|styles)\.xml\z}) }

        object_templates = {}
        object_entries.each { |name| object_templates[name] = zipfile.read(name) }

        objects_by_dir = object_templates.keys.group_by { |name| name.split('/').first }

        # Find highest existing object number for generating unique names
        max_obj_num = zipfile.entries.map(&:name)
          .grep(%r{\AObject (\d+)/}) { $1.to_i }.max || 0

        # Pre-read all object-related files for copying to duplicates
        object_all_files = {}
        zipfile.entries.each do |entry|
          name = entry.name
          if name.match?(%r{\AObject \d+/}) || name.match?(%r{\AObjectReplacements/Object \d+\z})
            object_all_files[name] = zipfile.read(name)
          end
        end

        # Counters and results shared by processor lambdas
        obj_counter = Hash.new(0)
        obj_results = {}

        # Build a processor lambda per object directory.
        # Each call evaluates the embedded template with the current binding
        # (capturing loop variables like `person`), saves/restores _buf to avoid
        # clobbering the outer template buffer, and stores the result keyed by
        # iteration number.
        processors = {}
        objects_by_dir.each do |obj_dir, obj_files|
          processors[obj_dir] = lambda do |ctx|
            buf_save = ctx.local_variable_get(:_buf)

            obj_counter[obj_dir] += 1
            n = obj_counter[obj_dir]

            obj_files.each do |name|
              file_part = name.split('/').last
              obj_results["#{obj_dir}__#{n}/#{file_part}"] =
                OdtEruby.new(XmlReader.new(object_templates[name])).evaluate(ctx)
            end

            ctx.local_variable_set(:_buf, buf_save)
          end
        end

        %w(content.xml styles.xml).each do |xml_file|
          content = zipfile.read(xml_file)

          # Images replacement
          images_replacements = ImagesProcessor.new(content, context).generate_replacements
          images_replacements.each do |r|
            zipfile.replace(r.first, r.last)
          end

          # Inject inline processing for embedded objects at their draw:object
          # reference points so loop variables are in scope during evaluation
          if xml_file == 'content.xml' && !processors.empty?
            context.local_variable_set(:_serenity_processors, processors)

            objects_by_dir.each do |obj_dir, _|
              ref_pattern = /(<draw:object[^>]*?xlink:href="\.\/#{Regexp.escape(obj_dir)}"[^>]*?\/>.*?<\/draw:frame>)/m
              content = content.sub(ref_pattern, "\\1{% _serenity_processors['#{obj_dir}'].call(binding) %}")
            end
          end

          odteruby = OdtEruby.new(XmlReader.new(content))
          out = odteruby.evaluate(context)
          out.force_encoding Encoding.default_external

          # Post-process content.xml: give each loop iteration its own object
          if xml_file == 'content.xml'
            objects_by_dir.each do |obj_dir, obj_files|
              count = obj_counter[obj_dir]

              # Rename each draw:frame's object references to a unique object dir
              iteration = 0
              out = out.gsub(/<draw:frame[^>]*>.*?<\/draw:frame>/m) do |frame|
                if frame.include?("./#{obj_dir}")
                  iteration += 1
                  new_obj_dir = iteration == 1 ? obj_dir : "Object #{max_obj_num + iteration - 1}"
                  frame.gsub(obj_dir, new_obj_dir)
                else
                  frame
                end
              end

              # Write evaluated templates and supporting files for each iteration
              (1..count).each do |n|
                final_obj = n == 1 ? obj_dir : "Object #{max_obj_num + n - 1}"

                # Write evaluated content.xml / styles.xml
                obj_files.each do |name|
                  file_part = name.split('/').last
                  result = obj_results["#{obj_dir}__#{n}/#{file_part}"]
                  next unless result

                  result.force_encoding Encoding.default_external
                  tmpfiles << (file = Tempfile.new("serenity"))
                  file << result
                  file.close

                  final_name = "#{final_obj}/#{file_part}"
                  if zipfile.find_entry(final_name)
                    zipfile.replace(final_name, file.path)
                  else
                    zipfile.add(final_name, file.path)
                  end
                end

                # Copy non-template files (meta.xml, ObjectReplacements) for new objects
                next if n == 1
                object_all_files.each do |name, data|
                  next if object_templates.key?(name)

                  new_name = nil
                  if name.start_with?("#{obj_dir}/")
                    new_name = name.sub(obj_dir, final_obj)
                  elsif name == "ObjectReplacements/#{obj_dir}"
                    new_name = "ObjectReplacements/#{final_obj}"
                  end

                  if new_name
                    tmpfiles << (file = Tempfile.new("serenity"))
                    file.binmode
                    file << data
                    file.close
                    zipfile.add(new_name, file.path)
                  end
                end
              end
            end
          end

          tmpfiles << (file = Tempfile.new("serenity"))
          file << out
          file.close
          zipfile.replace(xml_file, file.path)
        end

        # Update manifest.xml with entries for new object directories
        if obj_counter.values.any? { |c| c > 1 }
          manifest = zipfile.read('META-INF/manifest.xml')
          new_entries = ""

          objects_by_dir.each do |obj_dir, _|
            count = obj_counter[obj_dir]
            (2..count).each do |n|
              new_obj = "Object #{max_obj_num + n - 1}"
              new_entries << %( <manifest:file-entry manifest:media-type="application/vnd.oasis.opendocument.chart" manifest:full-path="#{new_obj}/"/>\n)
              new_entries << %( <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="#{new_obj}/content.xml"/>\n)
              new_entries << %( <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="#{new_obj}/styles.xml"/>\n)
              if object_all_files["#{obj_dir}/meta.xml"]
                new_entries << %( <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="#{new_obj}/meta.xml"/>\n)
              end
              if object_all_files["ObjectReplacements/#{obj_dir}"]
                new_entries << %( <manifest:file-entry manifest:media-type="application/x-openoffice-gdimetafile;windows_formatname=&quot;GDIMetaFile&quot;" manifest:full-path="ObjectReplacements/#{new_obj}"/>\n)
              end
            end
          end

          manifest = manifest.sub("</manifest:manifest>", "#{new_entries}</manifest:manifest>")
          tmpfiles << (file = Tempfile.new("serenity"))
          file << manifest
          file.close
          zipfile.replace('META-INF/manifest.xml', file.path)
        end
      end
    end
  end
end
