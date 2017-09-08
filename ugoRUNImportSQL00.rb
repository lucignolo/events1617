#!/usr/local/bin/ruby

require "./ugoLib/ugorunnerXUtil01.rb"
mioScript = "ugoRUNImportSQL00.rb"
pippo = Konta.new("#{mioScript} - 07/08/17: crea un blocco di statement SQL per l'importazione di singoli bidoni","0")
INIZIO = 10001 #001 #1 #11 #15001  # è necessario assegnare un valore corretto, alla luce dei controlli di controllaInizio
FINE = 12698 #10000 #11031 #100  #16000
def controllaInizio( pippo)
  if INIZIO == 1 && FINE > INIZIO
    return true
  else
    ultimoBook = Book.last
  end  
  #ultimoBook = Book.last #<<=== cambiare (commentandola) questa istruzione per il primo ciclo di bidoni
  if INIZIO == ultimoBook.id+1  # 1  <<=== cambiare questa istruzione (mettere: INIZIO == 1) per il primo ciclo di bidoni
    return true
  else
    pippo.scriviRiga("Ultimo record in tabella books ha valore: #{ultimoBook.id}") if INIZIO > 1
    return false
  end
end #def
# ============================================================================
stampaSorgente = false 
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")
  nomeFileOutput = "./ugoLib/importazione/bloccoInsertSQL.txt"
  
  if controllaInizio(pippo)    
    intervallo = Range.new(INIZIO, FINE)
    pippo.scriviRiga(">>> File di scrittura per le istr. SQL: #{nomeFileOutput.upcase} .")
    pippo.scriviRiga(">>> valore di partenza: #{intervallo.min}, valore di arrivo: #{intervallo.max}.")
    f = File.new(nomeFileOutput, "w")

    base1 = "INSERT INTO books VALUES ("
    
    intervallo.each{|num| mioID=num
  	            mioVecchioID=num
  	            base2 =  ""
                base2 +=  "#{num},"           # id
                base2 +=  "#{mioID},"         # vecchioid
                base2 +=  "'titolobidone',"   # titolo
                base2 +=  "-1,"               # prezzoeurodec
                base2 +=  "'???',"            # edizione,
                base2 +=  "'???',"            # isbn
                base2 +=  "-1,"               # copie
                base2 +=  "'t',"              # deposito
                base2 +=  "-1,"               # publisher_id
                base2 +=  "-1,"               # idtipoopera
                base2 +=  "-1,"               # annoedizione
                base2 +=  "'???',"            # note
                base2 +=  "-1,"               # idaliquotaiva
                base2 +=  "'bidone',"         # url2
                base2 +=  "-1,"               # annomodifica
                base2 +=  "'2017-08/07 16:50:00.123456',"    # created_at
                base2 +=  "'2017-08/07 16:50:00.123456');"   # updated_at
                #       '203-06-05 17:37:34.490508','2013-06-26 14:04:26.782599',-99.99,-1,'t',-1,'bidone');"
  	            riga = base1+base2
  	            f.write("#{riga}\n")
  	            putc '.'}
                puts "\n"
    pippo.scriviRiga(">>> esecuzione terminata normalmente <<<") 
    pippo.scriviRiga(">>> puoi usare #{nomeFileOutput.upcase} per import BIDONE da RAZORsql.")                
  else #controlla
    riga = "Il valore assegnato alla costante INIZIO (#{INIZIO}) non è corretto. JOB ANNULLATO!"
    pippo.scriviRiga(riga)
    puts riga
  end # controlla

  pippo.scriviRiga("Risultati end#")

end # stampaSorgente
pippo.fineJob  