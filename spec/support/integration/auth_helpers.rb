module Integration
  module AuthHelpers
    def sign_in(user)
      visit sign_in_path
      fill_in 'Username', with: user.username
      fill_in 'Password', with: 'anything'
      click_on 'Sign in'
    end
  end
end
