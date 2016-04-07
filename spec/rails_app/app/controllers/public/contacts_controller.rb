module Public
  class ContactsController < BaseController
    include ContactFormHelper
    respond_to :html, :json

    def create
      contact_type = params[:contact_type]
      @contact_form = generate_contact_form(contact_type, params[contact_type])

      respond_with(@contact_form) do |format|
        if @contact_form.valid?
          @contact_form.deliver
          session.delete(:contact_form)

          format.html { redirect_to Settings.pages[:after_submit][contact_type][I18n.locale] }
          format.json { render json: { message: I18n.t('public.contacts.thanks'), redirect_to: Settings.pages[:after_submit][contact_type][I18n.locale] }, status: :ok }
        else
          session[:contact_form] = params[:contact_form]
          format.html { redirect_to Settings.pages[:contact_us] }
          format.json { render json: { errors: @contact_form.errors }, status: :unprocessable_entity }
        end
      end
    end
  end
end
