# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password Devise.friendly_token[0,20]
  end
end
