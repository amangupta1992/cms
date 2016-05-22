module AppliedCouponsHelper
  def AppliedCouponsHelper.create(user_id,coupon_id)
    applied_coupon = AppliedCoupon.new
    applied_coupon.user_id = user_id
    applied_coupon.coupon_id = coupon_id
    applied_coupon.save!
  end
end
