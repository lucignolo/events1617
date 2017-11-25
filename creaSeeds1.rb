#!/usr/local/bin/ruby   
# creaSeeds1.rb   17 novembre 2017
#  tentativo non documentato di leggere outrunner3.txt e creare qualhe record
#  per il file seeds.rb

require 'scanf'

OUTf = "mieiSeeds.txt"
INPf = "outrunner3.txt"
modStartRiga = /^(.)(\d\d)(.?)/
#
def interpretaRiga(riga)
end # interpretaRiga

puts "START creaSeeds1.rb"
date = "2017-11-17"
year, month, day = date.scanf("%4d-%2d-%2d")
puts "#{year} - #{month} - #{day}"
f1, f2, f3 = /(.)(.)(\d+)(\d)/.match("THX1138.").captures
puts "#{f1} #{f2} #{f3}"

puts "Inventory.delete_all"   # prima riga da mettere in seeds.rb

#--- inizia lettura INPf
File.open(INPf) do |out3|
  nr = 0	
  out3.each_line {|line|
    nr += 1  
    line = line.chomp
    puts "Got #{ line.dump}..."
    if nr <= 2
	else
    	starter, resto, dati = modStartRiga.match(line).captures
  		if starter == "=" && !resto.nil?  	 
  	 		tipoRiga = resto.to_1
  	 		puts "#{starter}#{resto}..#{dati}"
  	 		#puts "tipoRiga,resto capt: #{tipoRiga}, #{resto}"
  	 		case
  	 			when tipoRiga == 1
  	 				puts "---"
  	 		    		
  	 			else
  	 				puts "???"
  	 		end  	
  		end
  	end
  	break if nr >= 10
  }
end
#--- fine lettura INPf

puts "FINE creaSeeds1.rb"