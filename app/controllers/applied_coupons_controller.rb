class AppliedCouponsController < ApplicationController
  def display
    render :json => AppliedCoupon.all
  end
end
