FactoryBot.define do
  factory :user do
    name { 'test' }
    email { 'test@example.com' }
    password { 'password' }

    trait :invalid_signup do
      email { '' }
    end

    trait :with_avatar do
      avatar { File.open(Rails.root.join('spec/factories/avatar/valid_image.jpg')) }
    end
  end
end
