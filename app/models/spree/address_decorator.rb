Spree::Address.class_eval do

  reject_validation = [:phone, :lastname, :firstname]

  reject_validation.each do |reject_key|

  _validators.reject!{ |key, value| key == reject_key }
  _validate_callbacks.each do |callback|
     callback.raw_filter.attributes.reject! { |key| key == reject_key } if callback.raw_filter.respond_to?(:attributes)
  end
  end
end
