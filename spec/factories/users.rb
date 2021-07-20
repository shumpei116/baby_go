FactoryBot.define do
  factory :user do
    name { 'test' }
    email { 'test@example.com' }
    password { 'password' }

    trait :invalid_signup do
      email { '' }
    end

    trait :with_avatar do
      avatar { File.open(Rails.root.join('spec/factories/test_image.jpg')) }
    end
  end
end
