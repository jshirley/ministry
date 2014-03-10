Given(/^a registered user as "([^"]*?)"$/) do |email|
  @passwords = {} if @passwords.nil?

  password = @passwords[email] = Devise.friendly_token

  steps %Q{
    When I sign out
    And I register a new account as "#{email}" with password "#{password}"
  }
end

# "([^"]*?)"

When(/^I register a new account as "([^"]*?)" with password "([^"]*?)"$/) do |email, password|
  visit new_user_registration_path
  fill_in('user[email]', with: email)
  fill_in('user[password]', with: password)
  fill_in('user[password_confirmation]', with: password)
  click_button 'Sign up'
end

When(/^I register a new account as "([^"]*?)"$/) do |email|
  password = Devise.friendly_token

  @passwords = {} if @passwords.nil?
  @passwords[email] = password

  visit new_user_registration_path
  fill_in('user[email]', with: email)
  fill_in('user[password]', with: password)
  fill_in('user[password_confirmation]', with: password)
  click_button 'Sign up'
end

When(/^I sign in as "(.*?)"$/) do |email|
  steps %Q{
    When I sign out
  }

  visit root_path
  click_link 'Sign in'
  within 'form.new_user' do
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: @passwords[email]
    click_button 'Sign in'
  end
end

When(/^I sign out$/) do
  visit root_path
  if has_link?('Sign out')
    click_link 'Sign out'
  end
end

Then(/^I should see a translated message "(.*?)"$/) do |message|
  page.should have_selector ".alert", text: I18n.t(message)
end

