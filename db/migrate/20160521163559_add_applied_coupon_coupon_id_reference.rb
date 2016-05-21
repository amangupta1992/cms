class AddAppliedCouponCouponIdReference < ActiveRecord::Migration
  def up
    add_foreign_key :applied_coupons, :coupons
  end
  def down
    remove_foreign_key :applied_coupons, :coupons
  end
end
