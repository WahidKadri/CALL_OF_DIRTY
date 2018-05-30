Bin.destroy_all

colors = ["jaune", "blanc", "vert"]

colors.each do |color|
  Bin.create(color: color)
end
