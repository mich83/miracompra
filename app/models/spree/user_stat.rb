class Spree::UserStat < ActiveRecord::Base

  def to_hash
    hash = {};
    params = [:comisiones, :bono, :comercializacion, :c_limite, :esp_recompra, :esp_factura, :acreditado]
    params.each { |k| hash[k] = send k }
    return hash
  end
end
