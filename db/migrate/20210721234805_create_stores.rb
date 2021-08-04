class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :introduction, null: false
      t.integer :postcode, null: false
      t.integer :prefecture_code, null: false
      t.string :city, null: false
      t.string :url
      t.string :image
      t.timestamps
    end
  end
end
