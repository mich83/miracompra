Spree::Api::ApiHelpers.module_eval do
  mattr_reader :invitation_attributes
  Spree::Api::ApiHelpers::ATTRIBUTES << :invitation_attributes
  @@invitation_attributes = [
      :id,
      :name,
      :message
  ]
end