#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

mioScript = "ugoRUNTravasaIVA.rb"
intestazione = "#{mioScript} - 04Nov.2016(15-08-17): verifica stato idaliquotaIVA nelle due tabelle"
puts intestazione
pippo = Konta.new(intestazione,"0")

def mostraSpiegazioni()
spiega = <<END_OF_STRING
\nQuesto script tratta l'attributo c14_idaliquotaiva come appare
nella tabella lbooks (e, in sola lettura, l'attribute idaliquotaiva di books).
Esso è in grado di indicare il numero di record presenti nelle due tabelle
raggruppati in base ai diversi valori di questi codici, oppure di trasformare 
i valori dei codici presenti in nuovi valori (l'operazione di trasformazione
è al momento limitata alla tabella lbooks).
Lo script richiede al massimo un argomento sulla command line. Se gli argomenti sono più di 1,
viene impostata la azione STOP\n
I possibili valori del parametro sono:
  1, per INFO: (mostra le frequenze di tutti i valori dei due codici nelle due tabelle);
  2, per SOSTITUISCI: (in lbooks sostituisce i valori nil del codice con il valore XX)
                      e il valore 22 del codice con il valore YY) 
  3, per RIPRISTINA: esegue la operazione inversa della SOSTITUISCI
  9, per STOP: presenta solamente questa informazione e termina la esecuzione
\n\n
END_OF_STRING
puts spiega
end #def mostraSpiegazioni 

#01. display spiegazioni a video
mostraSpiegazioni()

#02. imposta il valore di azione sulla base del parametro letto in ARGV[1]
INFO        = 1
SOSTITUISCI = 2
RIPRISTINA  = 3
STOP        = 4

simboliAzione = []
simboliAzione << "INFO" << "SOSTITUISCI" << "RIPRISTINA" << "STOP"
puts "#{simboliAzione.inspect}"

azione = INFO
puts "You gave #{ARGV.size} arguments: #{ARGV[0]}"
case 
   when ARGV.size == 0
     azione = INFO
   when ARGV.size == 1 && ARGV[0].to_i == 1
     azione = INFO 
   when ARGV.size == 1 && ARGV[0].to_i == 2         
     azione = SOSTITUISCI 
   when ARGV.size == 1 && ARGV[0].to_i == 3  
     azione = RIPRISTINA  
   when ARGV.size == 1 && ARGV[0].to_i == 4  
     azione = STOP        
   when ARGV.size > 1 
     azione = STOP 
end #case
puts "#{azione}"
puts "L'azione che verrà ora eseguita è la numero #{azione}, ossia #{simboliAzione[azione - 1]}."

# predispone un metodo parametrizzato per la sostituzione
def sosti(attuale, nuovo, pippo)
=begin rdoc
Esegue l'update di una serie di record, sostituendo in ciascuno di essi, per un campo predefinito,
che al momento è l'attribute c14_idaliquotaiva della tabella, anch'essa predefinita (lbooks),
il valore che i record contengono (vecchio), con un diverso valore (nuovo).
La procedura avviene in due fasi: nella prima vengono estratti i record che contengono il valore
nuovo nel campo predefinito. nella seonda viene applicato al risultato il metodo update_all
Scrive alcune informazioni sul log, che è rappresentato dalla variabile pippo
=end
  commento1  = "Esegue la sostituzione del campo c14_idaliquotaiva in lbooks "
  commento2 = "per tutti i record contenenti il valore #{attuale} con il valore #{nuovo}." 
  puts commento1
  puts commento2
  pippo.scriviRiga(commento1)
  pippo.scriviRiga(commento2)
  
  #
  rDaToccare = Lbook.where( c14_idaliquotaiva: attuale)
  quanti = rDaToccare.size
  if quanti > 0
         quante = rDaToccare.update_all( c14_idaliquotaiva: nuovo)
         riga = "n.ro sostituzioni da #{attuale} a #{nuovo} eseguite: #{quante} su #{quanti}"
         puts riga
         pippo.scriviRiga(riga)
  else 
         riga = "nessun record presente con c14_idaliquotaiva = #{attuale}"  
         puts riga 
         pippo.scriviRiga(riga)
  end #if quanti > 0 
end #def sosti(attuale, nuovo, pippo)
# un secondo metodo per calcolare la situazione delle frequenze nelle due tabelle
def informa(pippo)
     # 1. Calcolo i valori di c14_idaliquotaiva e la loro frequenza in lbooks
     ivaInLbooks = Lbook.gruppiIVA
     risultL = "1. Segue hash ivaInLbooks: #{ivaInLbooks.inspect}"
     pippo.scriviRiga(risultL)

     # 2. Calcolo i valori di idaliquotaiva e la loro frequenza in books
     ivaInBbooks = Book.gruppiIVA
     risultB = "2. Segue hash ivaInBbooks: #{ivaInBbooks.inspect}"
     pippo.scriviRiga(risultB) 
end #def informa(pippo) 

# =======================================================================
stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")  
  pippo.scriviRiga("Ruby version: #{RUBY_VERSION}, PATCH LEVEL: #{RUBY_PATCHLEVEL}") 
  pippo.scriviRiga("azione da eseguire: #{azione}, ossia azione: #{simboliAzione[azione - 1]}.") 
  case azione
    when INFO  #ARGV[1] == 1 
      informa(pippo)

    when SOSTITUISCI # ARGV[1] == 2
      sosti( nil, 3, pippo)   # tratta i codici nil come codici = 3 (IVA=0)
      #
      sosti( 22, 2, pippo)    # tratta i codici 22 come codici = 2 (IVA=20 e dagli scorsi anni=22)
      #
      informa(pippo)      
    
    when RIPRISTINA 
      rexnulli = Lbook.where( c14_idaliquotaiva: '5')
      quantiexnulli = rexnulli.size
      if quantiexnulli > 0
         quante = rexnulli.update_all( c14_idaliquotaiva: nil)
         riga = "n.ro sostituzioni da 5 a nil eseguite: #{quante} su #{quantiexnulli}"
         puts riga
         pippo.scriviRiga(riga)
      else 
         riga = "nessun record presente con c14_idaliquotaiva = 5"  
         puts riga 
         pippo.scriviRiga(riga)
      end #if quantiexnulli > 0 
      riga = "frequenze dopo questa azione: #{Lbook.gruppiIVA.inspect}" 
      pippo.scriviRiga(riga)      

    when STOP
      riga = "numero di argomenti maggiore del richiesto"  
      puts riga
      pippo.scriviRiga(riga)

  end # case azione 
  pippo.scriviRiga("Risultati end#")
  
end # stampaSorgente
pippo.fineJob
