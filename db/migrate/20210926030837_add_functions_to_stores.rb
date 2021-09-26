class AddFunctionsToStores < ActiveRecord::Migration[6.1]
  def change
    add_column :stores, :nursing_room, :boolean, default: false
    add_column :stores, :diaper_changing_area, :boolean, default: false
    add_column :stores, :hot_water, :boolean, default: false
    add_column :stores, :stroller_rental, :boolean, default: false
    add_column :stores, :kids_space, :boolean, default: false
    add_column :stores, :large_space, :boolean, default: false
    add_column :stores, :height_and_weight_scales, :boolean, default: false
    add_column :stores, :microwave_oven, :boolean, default: false
    add_column :stores, :basin, :boolean, default: false
    add_column :stores, :toilet_with_baby_chair, :boolean, default: false
    add_column :stores, :tatami_room, :boolean, default: false
    add_column :stores, :private_room, :boolean, default: false
    add_column :stores, :baby_food, :boolean, default: false
    add_column :stores, :stroller_access, :boolean, default: false
    add_column :stores, :baby_chair, :boolean, default: false
  end
end
