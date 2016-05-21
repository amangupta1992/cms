class CreateAppliedCoupons < ActiveRecord::Migration
  def change
    create_table :applied_coupons do |t|
      t.integer :user_id, :limit => 11
      t.integer :coupon_id, :limit => 11, null: false
      t.timestamps null: false
      t.boolean :is_delete, null: false, default: false
    end
  end
end
