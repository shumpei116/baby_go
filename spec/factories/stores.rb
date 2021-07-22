FactoryBot.define do
  factory :store do
    association :user
    name { '赤ちゃんの本舗' }
    introduction { '授乳室とおむつ交換スペースが完備！　綺麗で広くてとっても利用しやすいです' }
    postcode { '3120005' }
    prefecture_code { '8' }
    city { 'ひたちなか市新光町35' }
    url { 'https://stores.akachan.jp/224' }
  end
end
