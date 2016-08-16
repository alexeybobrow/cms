module Integration
  module MetaTagsHelpers
    def fill_in_tag(name, options)
      elem = page.all(:xpath, "//input[starts-with(@name, 'page[meta]') and substring(@name, string-length(@name) - string-length('[#{name}]') +1) = '[#{name}]']").last
      elem.set(options[:with])
    end
  end
end
