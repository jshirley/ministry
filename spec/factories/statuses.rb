# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    name "Pending"
    description "This is the pending status, projects here are not ready for staffing"
    next_status_id 1
  end
end
