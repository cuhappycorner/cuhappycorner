require File.expand_path("../../../config/environment", __FILE__)

matrix = Computer.new
I18n.locale = :en
matrix.name = "The Matrix" 
I18n.locale = :zh_HK
matrix.name = "母體"
matrix.save