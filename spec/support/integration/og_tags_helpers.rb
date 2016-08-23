module Integration
  module MetaTagsHelpers
    def fill_in_tag(name, options)
      if within_class = options[:within_class]
        tag_scope = "//*[@class=\"#{within_class}\"]"
      else
        tag_scope = ""
      end

      xpath = "#{tag_scope}//input[starts-with(@name, 'page[meta]') and substring(@name, string-length(@name) - string-length('[#{name}]') +1) = '[#{name}]']"
      elem = page.all(:xpath, "#{tag_scope}//input[starts-with(@name, 'page[meta]') and substring(@name, string-length(@name) - string-length('[#{name}]') +1) = '[#{name}]']").last
      binding.pry
      elem.set(options[:with])
    end
  end
end
