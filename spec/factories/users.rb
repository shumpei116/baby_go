FactoryBot.define do
  factory :user do
    name { 'test' }
    email { 'test@example.com' }
    password { 'password' }

    trait :invalid_signup do
      email { '' }
    end
  end
end
