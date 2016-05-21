class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :coupon_code, null: false
      t.string :coupon_type, null: false
      t.datetime :valid_upto
      t.integer :usage_count, :limit => 11
      t.integer :usage_limit, :limit => 11
      t.timestamps null: false
      t.boolean :is_delete, null: false, default: false
    end
  end
end
