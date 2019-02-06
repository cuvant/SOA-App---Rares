FactoryGirl.define  do
  factory :user do
    sequence(:email) { |n| "name#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end
end
