class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :rating, null: false, default: 0
      t.text :comment, null: false

      t.timestamps
      t.index [:store_id, :user_id], unique: true
    end
  end
end
