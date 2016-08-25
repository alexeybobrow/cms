module Integration
  module MetaTagsHelpers
    def fill_in_tag(name, options)
      if within_class = options[:within_class]
        tag_scope = "//*[contains(@class, \"#{within_class}\")]"
      else
        tag_scope = ""
      end

      elem = page.all(:xpath, "#{tag_scope}//input[starts-with(@name, 'page[meta]') and substring(@name, string-length(@name) - string-length('[#{name}]') +1) = '[#{name}]']").last
      elem.set(options[:with])
    end
  end
end
