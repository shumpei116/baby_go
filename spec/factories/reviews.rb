FactoryBot.define do
  factory :review do
    store { nil }
    user { nil }
    rating { 1.5 }
    comment { 'MyText' }
  end
end
