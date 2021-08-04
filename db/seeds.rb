# ユーザーを作成
User.create!(name:   "俊平",
            email:  "shumpei@example.com",
            introduction: "こんにちは！",
            password:              "111111",
            password_confirmation: "111111",
            avatar: open("#{Rails.root}/db/fixtures/avatar.jpg")
          )

#複数のユーザーをまとめて生成する
5.times do |n|
  name = "test-#{n+1}"
  email = "example-#{n+1}@example.com"
  introduction = "#{n+1}回目のこんにちは！"
  password = "password"
  User.create!(name:  name,
               email: email,
               introduction: introduction,
               password:              password,
               password_confirmation: password
              )
end

# 施設データを生成する
user = User.first
3.times do |n|
  user.stores.create!(name:   "東松屋",
                    introduction: "綺麗な授乳室が#{n+1}部屋あります",
                    postcode:     "987654#{n}",
                    prefecture_code: "北海道",
                    city: "テスト町テスト1-2-3-#{n}",
                    url: "https://test.example.com",
                    image: open("#{Rails.root}/db/fixtures/test-#{n+1}.jpg")
                  )
end

# ページネーション用に追加で施設データを生成する
12.times do |n|
  user.stores.create!(name:   "東松屋",
                    introduction: "綺麗な授乳室が#{n+1}部屋あります",
                    postcode:     "12332#{n+10}",
                    prefecture_code: "北海道",
                    city: "赤ちゃん町ベイビー#{n}",
                    url: "https://test.example.com",
                    image: open("#{Rails.root}/db/fixtures/test-3.jpg")
                  )
end


# 複数の施設データをまとめて生成する
users = User.all

users.each_with_index do |user, index|
  name = "テスト本舗- #{index}"
  introduction = "広いおむつ交換スペースが#{index}部屋ありました！"
  postcode = "123456#{index}"
  prefecture_code = "東京都"
  city = "テスト市ベイビー#{index}番町"
  url = "https://test.example#{index}.com"
  user.stores.create!(name:            name,
                      introduction:    introduction,
                      postcode:        postcode,
                      prefecture_code: prefecture_code,
                      city:            city,
                      url:             url,
                      image: open("#{Rails.root}/db/fixtures/test-1.jpg")
                    )
end
