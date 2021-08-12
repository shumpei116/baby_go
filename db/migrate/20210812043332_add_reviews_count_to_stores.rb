class AddReviewsCountToStores < ActiveRecord::Migration[6.1]
  def self.up
    add_column :stores, :reviews_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :stores, :reviews_count
  end
end
