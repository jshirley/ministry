# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    project nil
    name "MyString"
    admin false
  end
end
