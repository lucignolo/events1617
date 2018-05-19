#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

mioScript = "ugoRUNExportTable1.rb"
intestazione = "#{mioScript} - 03 maggio 2018: crea records per seeds.rb"
puts intestazione
pippo = Konta.new(intestazione,"0")

def staRiga(riga, pippo)
  puts riga
  pippo.scriviRiga(riga) 
end #def sta(riga, pippo)

def fai_blocco_pubs(pippo)
  riga = "prova - 123"
  puts riga
  pippo.scriviRiga(riga)

   recordZ="# . . ."
   ncanc = 0   #variabile globale di comodo
   fatti = 0
    # Sost. in ogni carrello più esemplari di un singolo prodotto  con un unico articolo
    Publisher.all.each do |pub|   
      recordX = "Publisher.create!(nome: "   #inizia X 
      recordX += "%{"              #apre blocco %{}
      recordX += pub.nome.strip    #inserisce il campo nome trimmato
      recordX +="},"               #termina il recordX con un } e virgola
      puts recordX
      #
      # ora facciamo recordW
      recordW = "vecchioid: #{pub.vecchioid} )"
      puts recordW
      # ora chiudiamo con recordZ
      puts recordZ
      #
      fatti += 1
      if fatti < 20
      else
        exit
      end
    end #Publisher.all.each 

    
end


# =======================================================================
stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")  
  pippo.scriviRiga("Ruby version: #{RUBY_VERSION}, PATCH LEVEL: #{RUBY_PATCHLEVEL}")
  # manda in esecuzione il metodo fai_blocco_pubs
  fai_blocco_pubs(pippo)

pippo.scriviRiga("Risultati end#")     
end # stampaSorgente


        
     
      

