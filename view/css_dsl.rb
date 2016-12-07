require_relative('../controller/builders')

module CSS_DSL

    def export(css)
      export_as "#{$0.split('.')[0]}.css", css
    end

    def export_as(name, css)
      file_name = name.downcase.end_with?('.css') ? name : "#{name}.css"
      File.delete(file_name) if File.exist?(file_name)
      File.write(file_name, css)
    end

    def css(&bk)
      builder = SheetBuilder.new
      builder.instance_eval(&bk)
      builder.build.to_s
    end

end