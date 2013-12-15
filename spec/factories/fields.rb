# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field do
    name "MyString"
    description "MyText"
    placeholder "MyText"
    type ""
    required false
    row_order 1
  end
end
