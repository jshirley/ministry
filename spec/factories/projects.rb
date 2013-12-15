# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "Test Project"
    association :user, factory: :user
    association :status, factory: :status
  end
end
