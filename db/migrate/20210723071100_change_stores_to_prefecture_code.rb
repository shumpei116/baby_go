class ChangeStoresToPrefectureCode < ActiveRecord::Migration[6.1]
  def change
    change_column :stores, :prefecture_code, :string
  end
end
