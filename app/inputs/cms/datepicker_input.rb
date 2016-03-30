module Cms
  class DatepickerInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      value = @builder.object.send(attribute_name)
      input_html_options[:value] = case value
                                   when Date, Time, DateTime
                                     format = options[:format] || :medium
                                     value.strftime(format)
                                   else
                                     value.to_s
                                   end

      input_html_options[:class] ||= []
      input_html_options[:class] << "date_picker_input"
      @builder.text_field(attribute_name, input_html_options)
    end
  end
end
