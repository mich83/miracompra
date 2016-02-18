#Deface::Override.new(:virtual_path => "spree/products/show",
#		     :name => "product_image_attr",
#		     :set_attributes => "div.panel-body img",
#		     :attributes => {:class=>"test"})
#Deface::Override.new(:virtual_path => "spree/products/show",
#		     :name => "product_image",
#		     :surrond_contents => "div.panel-body",
#		     :text => "<ul id='etalage'><li><%= render_original %></li></ul>")