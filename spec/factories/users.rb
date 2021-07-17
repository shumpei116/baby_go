FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@example.com" }
    password { "password" }

    trait :invalid do
      email { "" }
    end
  end
end
