FactoryBot.define do
  factory :store do
    association :user, strategy: :create
    name { '赤ちゃんの本舗' }
    introduction { '授乳室とおむつ交換スペースが完備！　綺麗で広くてとっても利用しやすいです' }
    postcode { '3120005' }
    prefecture_code { '栃木県' }
    sequence(:city) { |n| "ひたちなか市新光町35#{n}" }
    url { 'https://stores.akachan.jp/224' }

    trait :invalid do
      name { '' }
    end

    trait :with_image do
      image { File.open(Rails.root.join('spec/factories/image/valid_image.jpg')) }
    end

    trait :rated1 do
      after(:create) do |store|
        create(:review, store: store, rating: '4')
        create(:review, store: store, rating: '4')
        create(:review, store: store, rating: '4')
      end
    end

    trait :rated2 do
      after(:create) do |store|
        create(:review, store: store, rating: '3')
        create(:review, store: store, rating: '3')
        create(:review, store: store, rating: '3')
      end
    end

    trait :rated3 do
      after(:create) do |store|
        create(:review, store: store, rating: '2')
        create(:review, store: store, rating: '2')
        create(:review, store: store, rating: '2')
      end
    end
  end
end
