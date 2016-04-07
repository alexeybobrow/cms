RSpec.shared_examples "edit email settings" do |form_name|
  it "allows to edit #{form_name.humanize} email" do
    visit edit_admin_email_path(id: form_name)

    fill_in 'Email', with: "new_#{form_name}_email@example.com"
    click_on 'Update'

    expect(page).to have_content("new_#{form_name}_email@example.com")
  end
end
