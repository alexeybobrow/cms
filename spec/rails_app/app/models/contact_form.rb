class ContactForm < MailForm::Base
  attribute :name,         validate: true
  attribute :email,        validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message,      validate: true

  def headers
    {
      subject: SiteSettings['contact_form']['subject'],
      to: SiteSettings['contact_form']['email'],
      from: %("#{name}" <#{email}>)
    }
  end
end
