Spree::BaseHelper.class_eval do

  def strip_tags(str)
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    str.gsub(re, '')
  end

  def meta_data
    object = instance_variable_get('@'+controller_name.singularize)
    meta = {}

    if object.kind_of? ActiveRecord::Base
      meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
      meta[:description] = object.meta_description if object[:meta_description].present?
    end

    if meta[:description].blank? && object.kind_of?(Spree::Product)
      meta[:description] = truncate(strip_tags(object.description).split.join(" "), length: 160, separator: ' ')
      meta[:'og:image'] = request.protocol + request.host_with_port + product_image_url(object)
    end

    meta.reverse_merge!({
                            keywords: current_store.meta_keywords,
                            description: current_store.meta_description,
                        }) if meta[:keywords].blank? or meta[:description].blank?
    meta
  end


  def method_missing(method_name, *args, &block)
    Rails.logger.debug "METHOD_MISSING #{method_name} #{args.inspect}"
    if image_style = image_style_from_method_name(method_name)
      define_image_method(image_style)
      self.send(method_name, *args)
    elsif image_style = image_url_style_from_method_name(method_name)
      define_image_url_method(image_style)
      result = self.send(method_name, *args)
      Rails.logger.debug "SUCCESSFULL CALL WITH RESULT: #{result}"
      return result
    else
      super
    end
  end

  def image_url_style_from_method_name(method_name)
    if method_name.to_s.match(/_image_url$/) && style = method_name.to_s.sub(/_image_url$/, '')
      possible_styles = Spree::Image.attachment_definitions[:attachment][:styles]
      style if style.in? possible_styles.with_indifferent_access
    end
  end


  def define_image_url_method(style)
    self.class.send :define_method, "#{style}_image_url" do |product|
        if product.images.empty?
        if !product.is_a?(Spree::Variant) && !product.variant_images.empty?
           return product.variant_images.first.attachment.url(style)
        else
          if product.is_a?(Spree::Variant) && !product.product.variant_images.empty?
            return product.product.variant_images.first.attachment.url(style)
          else
            return "noimage/#{style}.png"
          end
        end
      else
        return product.images.first.attachment.url(style)
      end
    end
  end

  def self.run_tree_query(condition)
    query = "create temp table r1 as select rr.user_id a, r.user_id b from spree_referred_records r join spree_referrals rr on r.referral_id=rr.id where not rr.user_id is null union select user_id, user_id from spree_referred_records"
    ActiveRecord::Base.connection.execute(query)
    m = 1
    n = 1024
    while m < n
      query = "create temp table r#{m*2} as select distinct p1.a, p2.b from r#{m} as p1 join r#{m} as p2 on p1.b = p2.a"
      ActiveRecord::Base.connection.execute(query)
      query= "drop table r#{m}"
      ActiveRecord::Base.connection.execute(query)
      m = m*2
    end
    query = "select a parent, b child from r#{m} where #{condition}"
    result = ActiveRecord::Base.connection.execute(query)
    ActiveRecord::Base.connection.execute("drop table r#{m}")
    result
  end

  def self.update_patrocinador new_patrocinador_code, users
    patrocinador_ref = Spree::Referral.find_by_code(new_patrocinador_code)
    users.each do |user_code|
      user = Spree::Referral.find_by_code(user_code).user
      rr = user.referred_record
      rr.referral = patrocinador_ref
      rr.save!
      user.save!
    end
  end

end