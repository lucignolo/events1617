#!/usr/local/bin/ruby
base0 = "@book.update_attribute(XXX,YYY)"
provaHash = Hash(titolo:   Hash(ok: ["titolononbidone","titoloqualunque"], nok: ["titolobidone"]),
	             copie:    Hash(ok: [1, 2, 50]                           , nok: [0, -1]),
                 deposito: Hash(ok: [false]                              , nok: [true]) 
                )
p provaHash.inspect

provaHash.each do |kcond, vcond|
	p kcond
	p vcond
	vcond[:ok].each.with_index do |valore, indice|	   
p "---...---...#{valore.inspect} #{indice}"
       base0 = "@book.update_attribute(XXX,YYY)"
       nomeCampo = "'#{kcond.to_s}'"
       modiA = base0.gsub(/XXX/, nomeCampo)
       #
	   case kcond
	   when :titolo
	   	 valoreCampo = "'#{valore}'"
	     modif = modiA.gsub(/YYY/, valoreCampo)
	   when :copie
	   	 valoreCampo = valore.to_s
	     modif = modiA.gsub(/YYY/, valoreCampo)  
	   when :deposito
	   	 valoreCampo = 'false' if !valore
	   	 valoreCampo = 'true' if valore
	     modif = modiA.gsub(/YYY/, valoreCampo)  
	   else
	     modif = "non calcolato"
	   end	
       puts "gen: #{modif}"
    end       
#
	vcond[:nok].each.with_index do |valore, indice|
p "===...---...#{valore.inspect} #{indice}"
    #gen_modificaAttributo(kcond, valore)
    end	

end
