# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_value do
    project nil
    field nil
    user nil
    value "MyText"
  end
end
