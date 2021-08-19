FactoryBot.define do
  factory :review do
    association :store, strategy: :create
    association :user, strategy: :create
    rating { 3 }
    comment { 'テストレビューです' }

    trait :invalid do
      comment { '' }
    end
  end
end
