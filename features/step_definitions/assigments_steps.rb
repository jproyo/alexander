Given /^that I have a project (.*)$/ do |project_name|
  puts "Project #{project_name}" # express the regexp above with the code you wish you had
end

Given /^project (.*) has members (.*)$/ do |project_name, members|
  puts "Project #{project_name} #{members}" # express the regexp above with the code you wish you had
end

When /^I look for projects without roles$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see project (.*)$/ do |project_name|
  pending # express the regexp above with the code you wish you had
end

Then /^(.*) as members$/ do |members|
  pending # express the regexp above with the code you wish you had
end

