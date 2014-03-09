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
