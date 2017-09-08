#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

mioScript = "ugoRUNTest3Tabelle.rb"
intestazione = "#{mioScript} - 31ott.2016(15/08/17): test publishers, lbooks e books. db: corrente."
puts intestazione
pippo = Konta.new(intestazione,"0")

def mostraSpiegazioni()
spiega = <<END_OF_STRING
\nAccede in SOLA LETTURA a 3 tabelle: publishers, lbooks e books,
allo scopo di estrarne dati caratteristici utili per verificarne la validità.

Le tabelle accedute sono quelle contenute in development.sqlite3 che si trova
nella sezione app/db/ della cartella corrente.

END_OF_STRING
puts spiega
end #def mostraSpiegazioni 

#01. display spiegazioni a video
mostraSpiegazioni()

# definisce il metodo di accesso a publisher
def publ (pippo)  
      nPubRec = Publisher.tuttibase
      riga = "Tabella publishers; Numero Record; #{nPubRec.size} record;." 
      puts riga 
      pippo.scriviRiga(riga)

      # verifica che siano presenti tutti gli id
      # usa per questo scopo uno scope (tuttibase) che restituisce solo id, vecchioid e nome seguito
      # dallo scope di nome maxid (vedere model) 
      max_id = nPubRec.maxid 
      riga = "Tabella publishers; Massimo id; #{max_id};."
      puts riga
      pippo.scriviRiga(riga) 
      
      # verifica il valore massimo del campo vecchioid
      # usa per questo scopo uno scope (tuttibase) che restituisce solo id, vecchioid e nome 
      # al quale applichiamo lo scope maxvecchioid
      max_vecchioid = nPubRec.maxvecchioid
      riga = "Tabella publishers; Massimo vecchioid; #{max_vecchioid};."
      puts riga
      pippo.scriviRiga(riga) 

      # verifica numero dei record bidone stringa "nonono " in nome
      # usa per questo scopo uno scope (tuttibase) che restituisce solo id, vecchioid e nome 
      # al quale applichiamo lo scope maxvecchioid
      mieibidoni = nPubRec.bidoni
      riga = "Tabella publishers; Numero di bidoni presenti; #{mieibidoni.size};."
      staRiga(riga, pippo)

      # verifica che non esistano doppioni nei valori di vecchioid
      gruppiVID = Publisher.gruppiVECCHIOID
      primoPub = gruppiVID[1].inspect
      puts primoPub
      staRiga("Tabella publishers; Verifica duplicazioni vecchioid; #{gruppiVID.size};.", pippo )
end  #def publ

def lbook(pippo)
      # tuttibase è uno scope che corrisponde a una select con un elenco di campi limitato (vedi lbook.rb)
      nLbokRec = Lbook.tuttibase
      riga = "Tabella lbooks; Numero Record; #{nLbokRec.size} ;." 
      staRiga(riga, pippo)
      
      # controlla massimo e minimo valore della chiave principale (id)
      # utilizza la stessa relation usata sopra, alla quale applica i metodi maximum(id) e minimum(id)
      # definiti a p.259 del Sam Ruby. Questi due metodi sono, come nel caso di publisher,
      # definiti come scopes (di nome maxid e minid) definiti nel Lbook model
      min_id = nLbokRec.minid 
      riga = "Tabella lbooks; Valore minimo di id; #{min_id};."
      staRiga(riga, pippo)

      max_id = nLbokRec.maxid 
      riga = "Tabella lbooks; Valore massimo di id; #{max_id};."
      staRiga(riga, pippo)

      # verifica i valori minimo e massimo del campo c01_vecchioid
      # usa la collezione (relation, nLbokRec) già ricavata prima
      # alla quale vengono applicati due nuovi scope (minc01 e maxc01, vedi lbook.rb)
      min_vecchioid = nLbokRec.minc01
      riga = "Tabella lbooks; Minimo c01_vecchioid; #{min_vecchioid};."
      staRiga(riga, pippo)
      #      
      max_vecchioid = nLbokRec.maxc01
      riga = "Tabella lbooks; Massimo c01_vecchioid; #{max_vecchioid};."
      staRiga(riga, pippo)

      # verifica i valori minimo e massimo del campo c10_publisher_id (la chiave per accedere
      # al padre, publisher)
      # usa la collezione (relation, nLbokRec) già ricavata prima
      # alla quale vengono applicati due nuovi scope (minc10 e maxc10, vedi lbook.rb)
      min_publid = nLbokRec.minc10
      riga = "Tabella lbooks; Minimo c01_publisher_id; #{min_publid};."
      staRiga(riga, pippo)
      #      
      max_publid = nLbokRec.maxc10
      riga = "Tabella lbooks; Massimo c01_publisher_id; #{max_publid};."
      staRiga(riga, pippo)  

      # analizziamo la situazione per quanto riguarda c14_idaliquotaiva
      # creiamo un nuovo scope, di nome tuttiIVA, che contiene le due chiavi id e c01_vecchioid
      # e aggiunge c14_idaliquotaiva (ma non funzionerà con group: lo sostituiamo con Lbook.all)
      # qui ci interessa ricavare un array con i possibili valori di c14 e le relative frequenze
      # applichiamo lo scope già esistente, di nome gruppiIVA alla relazione indicata sopra 
      # attenzione! Possiamo eliminare lo scope tuttiIVA dal modello
      relTuttiConIVA = Lbook.all
      arrIVA_frequenze = relTuttiConIVA.gruppiIVA
      riga = "Tabella lbooks; valori e frequenze c14_idaliquotaiva; #{arrIVA_frequenze.inspect};."
      staRiga(riga, pippo)
end #def lbook(pippo)

def bbook(pippo)
      # tuttibase è uno scope che corrisponde a una select con un elenco di campi limitato (vedi book.rb)
      nBbokRec = Book.tuttibase
      riga = "Tabella books; Numero Record; #{nBbokRec.size} ;." 
      staRiga(riga, pippo)
      
      # controlla massimo e minimo valore della chiave principale (id)
      # utilizza la stessa relation usata sopra, alla quale applica i metodi maximum(id) e minimum(id)
      # definiti a p.259 del Sam Ruby. Questi due metodi sono, come nel caso di publisher e di lbooks,
      # definiti come scopes (di nome maxid e minid) definiti nel Lbook model
      min_id = nBbokRec.minid 
      riga = "Tabella books; Valore minimo di id; #{min_id};."
      staRiga(riga, pippo)

      max_id = nBbokRec.maxid 
      riga = "Tabella books; Valore massimo di id; #{max_id};."
      staRiga(riga, pippo)               

      # verifica i valori minimo e massimo del campo vecchioid
      # usa la collezione (relation, nBbokRec) già ricavata prima
      # alla quale vengono applicati due nuovi scope (minc01 e maxc01, vedi lbook.rb)
      min_vecchioid = nBbokRec.minvid
      riga = "Tabella books; Minimo vecchioid; #{min_vecchioid};."
      staRiga(riga, pippo)
      #      
      max_vecchioid = nBbokRec.maxvid
      riga = "Tabella books; Massimo vecchioid; #{max_vecchioid};."
      staRiga(riga, pippo)

      # conta i record bidoni e quelli nobidoni
      # utilizza non più lo scope tuttibase, che non contiene titolo, ma il nome del modello
      riga = "Tabella books; Numero di record bidone; #{Book.bidoni.count};."
      staRiga(riga, pippo)

      riga = "Tabella books; Numero di record nonbidone; #{Book.nobidoni.count};."
      staRiga(riga, pippo)

      riga = "Tabella books; verifica quadratura bidoni+nobidoni=maxid;"
      riga += "#{Book.bidoni.count + Book.nobidoni.count} (#{max_id});." 
      staRiga(riga, pippo)    

      # analizziamo la situazione per quanto riguarda idaliquotaiva
      # usiamo il modello direttamente
      relTuttiConIVA = Book.all
      arrIVA_frequenze = relTuttiConIVA.gruppiIVA
      riga = "Tabella books; valori e frequenze idaliquotaiva; #{arrIVA_frequenze.inspect};."
      staRiga(riga, pippo) 
=begin rdoc     
=end      
end #def bbook(pippo)




def staRiga(riga, pippo)
  puts riga
  pippo.scriviRiga(riga) 
end #def sta(riga, pippo)




# =======================================================================
stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")  
  pippo.scriviRiga("Ruby version: #{RUBY_VERSION}, PATCH LEVEL: #{RUBY_PATCHLEVEL}")
  # definisce l'hash mioDB
  mioDB = { :publ  => "publishers", :lbook => "lbooks" , :bbook => "books" }
  mioDB.each {|chiave, valore| 
    puts "chiave: #{chiave.to_s}, valore:#{valore.inspect}"
    case chiave
      when :publ
        puts "\tesamina la tabella #{valore} = publishers"
        publ(pippo)
      when :lbook
        puts "\n\tesamina la tabella #{valore} = lbooks"
        lbook(pippo)
      when :bbook
        puts "\n\tesamina la tabella #{valore} = books" 
        bbook(pippo)         
      else
        puts "\tcaso non implementato" 
    end 
  } 
pippo.scriviRiga("Risultati end#")     
end # stampaSorgente
pippo.fineJob
