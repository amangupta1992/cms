Rails.application.routes.draw do
    match 'api/create' => 'coupons#create', via: :post
    match 'api/update' => 'coupons#update', via: :post
    match 'api/apply' => 'coupons#apply', via: :post
    match 'get/all' => 'coupons#display', via: :get
    match 'get/applied' => 'applied_coupons#display', via: :get
end
