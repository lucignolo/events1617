#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

mioScript = "prova_metodoUP.rb"
intestazione = "#{mioScript} - 12 maggio 2017: prova metodo UP (Rails4, p.107)"
puts intestazione
pippo = Konta.new(intestazione,"0")

def staRiga(riga, pippo)
  puts riga
  pippo.scriviRiga(riga) 
end #def sta(riga, pippo)

def metodoUp(pippo)
  riga = "prova - 123"
  puts riga
  pippo.scriviRiga(riga)

   ncanc = 0   #variabile globale di comodo
    # Sost. in ogni carrello più esemplari di un singolo prodotto  con un unico articolo
    Cart.all.each do |cart|   
      # contate il numero di ciascun prodotto nel carrello    
      sums = cart.line_items.group(:product_id).sum(:quantity)
      ncanc = 0    
          
      sums.each do |product_id, quantity|   
        if quantity > 1 
          # Eliminate i singoli articoli
          cart.line_items.where(product_id: product_id).delete_all
          ncanc += 1
          
          # sostituite con un unico articolo
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end # if quantity 
        riga = "cart_id: #{cart.id}; product_id: #{product_id}, ncanc: #{ncanc}"
        puts riga

      end # sum.each    
    end #Cart.all.each 

    
end


# =======================================================================
stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")  
  pippo.scriviRiga("Ruby version: #{RUBY_VERSION}, PATCH LEVEL: #{RUBY_PATCHLEVEL}")
  # manda in esecuzione il metodo up
  metodoUp(pippo)

pippo.scriviRiga("Risultati end#")     
end # stampaSorgente


        
     
      

