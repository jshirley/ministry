# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    password Devise.friendly_token[0,20]

    sequence :email do |n|
      "email-#{n}@example.com"
    end
  end
end
