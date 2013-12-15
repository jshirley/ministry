# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :series do
    user nil
    name "MyString"
    start_date "2013-12-15"
    end_date "2013-12-15"
  end
end
