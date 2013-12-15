# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    name "MyString"
    description "MyText"
    next_status_id 1
  end
end
