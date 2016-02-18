class GeneratePredefinedCodes < ActiveRecord::Migration
  def change
    (0..1000000).each do |n|
      code = PredefinedCode.new
      code.code = "MC%06d" % n
      code.assigned = false
      code.save
    end
  end
end
