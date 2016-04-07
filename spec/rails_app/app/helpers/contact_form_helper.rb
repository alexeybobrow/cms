module ContactFormHelper
  def generate_contact_form(contact_type, options)
    case contact_type
      when 'contact_form' then ContactForm.new(options)
      when 'codereview_form' then CodereviewForm.new(options)
    end
  end
end
