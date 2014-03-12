When(/^create a (private|public) project called "(.*?)"$/) do |privacy, name|
  visit new_project_path

  fill_in('project[name]', with: name)

  if privacy == 'public'
    find(:css, 'input[name="project[public]"]').set(true)
  end

  page.all(:css, 'div.project_field_values_value textarea').each do |el|
    el.set('Testing this out, you can ignore this text but I should probably Lorem Ipsum it.')
  end

  click_button I18n.t('save_button_html')
end

Then(/^I should not find the project "(.*?)"$/) do |name|
  visit projects_path

  page.should have_no_content(name)
end

Then(/^I edit the project "(.*?)"$/) do |project|
  visit projects_path

  click_link project
  click_link I18n.t('edit_button_html')
end

Then(/^I should add (\d+) role called "(.*?)"$/) do |quantity, role|
  # We must be on the edit page already.
  within '.add-role' do
    fill_in 'role', with: role
    fill_in 'quantity', with: quantity
    click_link 'Add'
  end
end

Then(/^I view the role "(.*?)" on project "(.*?)"$/) do |role, project|
  visit projects_path
  click_link project

  within find('tr', text: role) do
    click_link 'Details'
  end
end

Then(/^I invite the user "(.*?)"$/) do |email|
  within 'form#new_membership' do
    fill_in 'membership[email]', with: email
    click_button I18n.t('invite_button_html')
  end
end

Then(/^I should have a pending invitation to "(.*?)" as a "(.*?)"$/) do |project, name|
  visit projects_path
  click_link project

  page.should have_selector "form.edit_membership"

  within "form.edit_membership" do
    page.should have_selector "input.btn-primary[value=#{I18n.t('accept_button_html')}]"
  end
end
