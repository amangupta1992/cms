class Coupon < ActiveRecord::Base
  validates :coupon_code, :coupon_type, :presence =>true
  validates_uniqueness_of :coupon_code

  validates_inclusion_of :coupon_type, :in => ["single-use", "single-use-per-user", "multi-use", "perpetual-use"]
  def coupon_type
    read_attribute(:coupon_type)
  end
  def coupon_type= (value)
    write_attribute(:coupon_type, value)
  end
end
