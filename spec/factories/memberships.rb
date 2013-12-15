# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    project nil
    user nil
    role nil
    accepted false
    approved false
    active false
    note "MyText"
  end
end
