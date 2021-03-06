# Baby_Go
授乳室やおむつ交換スペースが完備された施設、赤ちゃんと一緒に入れる飲食店などの情報を  
共有・検索する為のアプリです。  
<br> 
お出かけしたいけどいつ泣き出すかわからない自由奔放で可愛い赤ちゃん。  
「あの店授乳室あったっけ？、おむつを交換できるところはあったっけ？？」  
そんなとき、授乳室やおむつ交換エリアがあるお店、赤ちゃんがいても行ける飲食店を誰かが教えてくれればと感じ自分で作成しました。  
<br> 
<img width="1439" alt="スクリーンショット 2021-09-23 14 24 32" src="https://user-images.githubusercontent.com/67525034/134458633-653afead-e078-4420-9b33-0a8600ed98f6.png">
<br>
<br>
登録された施設は【現在地から探す】機能で地図上から探したり、住所・キーワード検索でも探すことが可能です。  
スマートフォンからの使用を想定してレスポンシブデザインにも対応しています。  
<br>
▼アプリURLはこちら▼  
[https://baby-go.jp](https://baby-go.jp)

## 使用技術
- Ruby 2.7.4
- Ruby on Rails 6.1.4
- MySQL 8.0
- Docker/Docker-compose
- Puma
- Nginx
- AWS
    - VPC
    - EC2
    - RDS
    - ALB
    - Route53
    - CloudFront
    - S3
- CI/CD CircleCI
- RSpec
- Rubocop
- Capistrano3
- Google Maps API

## AWS構成図
![Baby_Go AWS](https://user-images.githubusercontent.com/67525034/136121954-af981e6d-d8dc-4d6c-9e75-dedb4a372ae4.jpg)

- まだEC2とRDSの冗長化はしていませんが、今後の冗長化を想定して２つのリージョンを跨いでサブネット・セキュリーグループの作成をしております

### CircleCI CI/CD
- Githubへのpush時に自動でRuboCopとRSpecを実行します。
- mainブランチへのpushではRuboCopとRSpecが成功した場合にEC2へのデプロイが自動で行われます。

## 機能一覧
- ユーザー登録・ログイン機能（devise）
- ゲストログイン機能
- 施設投稿機能
    - 画像投稿機能（carriewave）
    - 位置情報取得機能（geocoder）
- いいね機能（Ajax）
    - いいね数カウント機能（counter_culture）
- 星レビュー機能（Ajax・raty.js）
    - ランキング機能
    - レビュー数カウント機能（counter_culture）
- SNSシェア機能
    - Twitter
    - Facebook
- ページネーション機能（kaminari）
- 検索機能（ransack）

## テストフレームワーク
- RSpec
    - factory_bot
    - model_spec
    - requests_spec
    - system_spec

## ER図
![Baby_Go ER図](https://user-images.githubusercontent.com/67525034/134800774-6f3bb702-dd3b-486e-b2d5-90cce8ccc3f4.png)