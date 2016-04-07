module Integration
  module OgTagsHelpers
    def fill_in_tag(name, options)
      elem = page.all(:xpath, "//input[starts-with(@name, 'page[og]') and substring(@name, string-length(@name) - string-length('[#{name}]') +1) = '[#{name}]']").last
      elem.set(options[:with])
    end
  end
end
