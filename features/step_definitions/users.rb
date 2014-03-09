When(/^I register a new account as "(.*?)"$/) do |email|
  password = Devise.friendly_token

  visit new_user_registration_path
  fill_in('user[email]', with: email)
  fill_in('user[password]', with: password)
  fill_in('user[password_confirmation]', with: password)
  click_button 'Sign up'
end

When(/^sign out$/) do
  page.driver.submit :delete, destroy_user_session_path, { }
end
