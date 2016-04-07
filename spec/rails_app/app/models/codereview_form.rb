class CodereviewForm < ContactForm
  def headers
    {
      subject: Settings[:codereview_form][:subject],
      to: Settings[:codereview_form][:email],
      from: %("#{name}" <#{email}>)
    }
  end
end
