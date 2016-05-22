class CouponsController < ApplicationController
  include AppliedCouponsHelper
  def create
    coupon = Coupon.new
    coupon.coupon_type = params[:type]
    valid_upto = params[:'valid-upto']
    if valid_upto != nil
      begin
        Date.parse(valid_upto)
      rescue ArgumentError
        render json: generate_response('not a date in valid-upto'),status: 400
        return
      end
      coupon.valid_upto = valid_upto
    end
    if coupon.coupon_type == 'single-use'
      coupon.usage_count = 0
      coupon.usage_limit = 1
    elsif coupon.coupon_type == 'single-use-per-user'
      coupon.usage_count = 0
    elsif coupon.coupon_type == 'multi-use'
      coupon.usage_count = 0
      coupon.usage_limit = params[:'n']
      if coupon.usage_limit == nil
        render json: generate_response('no use limit specified'),status: 400
        return
      elsif coupon.usage_limit.to_i == 0
        render json: generate_response('usage limit has to greater than 0 and a integer'),status: 400
        return
      end
    elsif coupon.coupon_type == 'perpetual-use'
      coupon.usage_count = 0
    else
      render json: generate_response('wrong type'),status: 400
      return
    end
    coupon.coupon_code = generate_random_coupon_code
    coupon.is_delete = false
    if coupon.save
      render json: success_response_for_coupon(coupon.id,coupon.coupon_code)
    else
      render json: generate_response(coupon.errors.full_messages)
    end
  end

  def update
    id = params[:id]
    valid_upto = params[:'valid-upto']
    usage_limit = params[:'n']
    if valid_upto != nil
      begin
        Date.parse(valid_upto)
      rescue ArgumentError
        render json: generate_response('Not a valid date.'),status: 400
        return
      end
    end
    coupon = Coupon.find(id)
    coupon.valid_upto = valid_upto
    if coupon.coupon_type == 'multi-use' and usage_limit != nil
        if coupon.usage_count <= usage_limit
          coupon.usage_limit = usage_limit
        else
          render json: generate_response('current usage count is greater than usage limit'),status: 400
          return
        end
    end
    if coupon.save
      render json: success_response_for_coupon(nil,nil)
    else
      render json: generate_response(coupon.errors.full_messages)
    end
  end

  def apply
    coupon_code = params[:coupon]
    user_id = params[:user_id]
    coupon = Coupon.find_by_coupon_code(coupon_code)
    if coupon == nil
      render json: generate_response('coupon code is expired')
      return
    end
    if coupon.valid_upto != nil and coupon.valid_upto < Time.now
      render json: generate_response('coupon code is expired')
      return
    end
    if coupon.coupon_type == 'single-use-per-user'
      if user_id != nil
        applied_coupon = AppliedCoupon.find_by(user_id: user_id, coupon_id: coupon.id)
        if applied_coupon != nil
          render json: generate_response('This coupon is single use coupon and already applied against your user')
          return
        end
      else
        render json: generate_response('This coupon is single use coupon and user id is required to apply this coupon')
        return
      end
    end
    if coupon.usage_limit == nil || coupon.usage_count < coupon.usage_limit
      coupon.usage_count = coupon.usage_count + 1
    else
      render json: generate_response('Limit of usage for this coupon has been reached')
      return
    end
    AppliedCouponsHelper.create(user_id,coupon.id)
    if coupon.save
      render json: success_response_for_coupon(nil,nil)
    else
      render json: generate_response(coupon.errors.full_messages)
    end
  end

  def display
    render :json => Coupon.all
  end

  private
  def coupon_params
    params.require(:coupon).permit(:coupon_code, :coupon_type, :valid_upto, :usage_count, :usage_limit, :is_delete)
  end
  def generate_random_coupon_code
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    coupon_code = (0...8).map { o[rand(o.length)] }.join
    if Coupon.find_by_coupon_code(coupon_code) != nil
      generate_random_coupon_code
    else
      coupon_code
    end
  end
  def generate_response (error_msg)
    response = Hash.new
    if error_msg !=nil
      response['error_message'] = error_msg
    end
    response.to_json
  end
  def success_response_for_coupon (coupon_id,coupon_code)
    response = Hash.new
    if coupon_id != nil
      response['id'] = coupon_id
    end
    if coupon_code != nil
      response['coupon'] = coupon_code
    end
    response.to_json
  end
end
