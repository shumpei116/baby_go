# ユーザーを作成
User.create!(name: '俊平',
             email: 'shumpei@example.com',
             introduction: 'こんにちは！',
             password: '111111',
             password_confirmation: '111111',
             avatar: open(Rails.root.join('db/fixtures/avatar.jpg')))

# 複数のユーザーをまとめて生成する
5.times do |n|
  name = "testパパ#{n + 1}"
  email = "example-#{n + 1}@example.com"
  introduction = "#{n + 1}回目のこんにちは！"
  password = 'password'
  User.create!(name: name,
               email: email,
               introduction: introduction,
               password: password,
               password_confirmation: password)
end

# 施設データを生成する
user1 = User.first
3.times do |n|
  user1.stores.create!(name: "東松屋 #{n}",
                       introduction: "綺麗な授乳室が#{n + 1}部屋あります",
                       postcode: "3190317",
                       prefecture_code: '茨城県',
                       city: "水戸市内原1−18#{n + 8}",
                       url: 'https://test.example.com',
                       image: open(Rails.root.join("db/fixtures/test-#{n + 1}.jpg")))
end

# ページネーション用に追加で施設データを生成する
16.times do |n|
  user1.stores.create!(name: "ばんどう三郎 #{n}",
                      introduction: "和室がたくさんあって子供と一緒でもゆっくりご飯が食べられます！",
                      postcode: "3114153",
                      prefecture_code: '茨城県',
                      city: "水戸市河和田町3829-#{n + 2}",
                      url: 'https://test.example.com',
                      image: open(Rails.root.join('db/fixtures/test-3.jpg')))
end

# 複数の施設データをまとめて生成する
users = User.all
users.each_with_index do |user, index|
  name = "ベイビー本舗- #{index}"
  introduction = "広いおむつ交換スペースが#{index}部屋ありました！"
  postcode = "3120005"
  prefecture_code = '茨城県'
  city = "ひたちなか市新光町#{35 + index}"
  url = "https://test.example#{index}.com"
  user.stores.create!(name: name,
                      introduction: introduction,
                      postcode: postcode,
                      prefecture_code: prefecture_code,
                      city: city,
                      url: url,
                      image: open(Rails.root.join('db/fixtures/test-1.jpg')))
end

# いいねデータを生成
favorite_users = users[0..4]
favorited_stores = Store.all[0..15]
favorite_users.each do |favorite_user|
  favorited_stores.each do |store|
    favorite_user.favorites.create!(store_id: store.id)
  end
end

# レビューデータを生成
review_users = users[0..6]
reviewed_stores = Store.all[5..20]
review_users.each do |review_user|
  reviewed_stores.each_with_index do |store, index|
    comment = "#{rand(1..15)}番目にいいところでした！！"
    review_user.reviews.create!(store_id: store.id, rating: rand(1..5), comment: comment)
  end
end