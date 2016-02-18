Spree::User.class_eval do
  def available_plans
    case current_plan
      when :inicial
        [:basico, :ejecutivo, :estrella]
      when :basico
        [:ejecutivo, :estrella]
      when :ejecutivo
        [:estrella]
      when :bronce, :plata, :oro, :diamante
        []
      else
        [:inicial, :basico, :ejecutivo, :estrella]
    end
  end

  def current_plan
    self.plan.nil? ? nil : self.plan.to_sym
  end

  def plan_description(new_plan)
    if self.plan.nil?
      new_plan.to_s
    else
      "#{self.plan}-#{new_plan.to_s}"
    end
  end

  def plan_no
    case current_plan
      when :catalogo
        1
      when :inicial
        2
      when :basico
        3
      when :ejecutivo
        4
      when :estrella
        5
      when :bronce
        6
      when :plata
        7
      when :oro
        8
      when :esmeralda
        9
      when :diamante
        10
      else
        0
      end
  end

  def plan_image
    "plan/image#{"%03d" % plan_no}.jpg"
  end

  def plan_presentation
    if plan.nil?
      "Consumidor final"
    else
      plan.capitalize
    end
  end
end