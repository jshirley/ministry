# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :milestone do
    project nil
    user nil
    name "MyString"
    date "2013-12-15"
    success false
  end
end
