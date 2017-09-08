#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

mioScript = "ugoRUNRicalcolaANNOMODIFICA.rb"
intestazione = "#{mioScript} - 08/09/2017: in books, ricalcola annomodifica per AI16"
puts intestazione
pippo = Konta.new(intestazione,"0")

def mostraSpiegazioni()
spiega = <<END_OF_STRING
\nAccede in LETTURA e SCRITTURA alla tabella books, nella quale in ugoRUNTravasa00.rb, è stato commesso un errore nel calcolo di annomodifica. Ricalcola il valore di questo attribute e salva i record cambiati.

Il metodo usato per calcolare annomodifica partendo dall'attribute url2, è il metodo estraiAnnoDaUrl2, che si trova definito in book.rb.

END_OF_STRING
puts spiega
end #def mostraSpiegazioni 

stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")  
  pippo.scriviRiga("Ruby version: #{RUBY_VERSION}, PATCH LEVEL: #{RUBY_PATCHLEVEL}")
  #01. display spiegazioni a video
  mostraSpiegazioni()

  #02 definisce hash htotaliInBooks con :crea
  bookOggetto = Book.first
  htotaliInBooks = bookOggetto.aggiungi(:crea) #{ tutti: 0, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0 }
  p "#{htotaliInBooks.inspect}"

   
  #03 corpo della parte esecutiva
  # dividiamo la tabella in gruppi in base al valore attuale di annomodifica
  frequenzeANNOMODIFICA = Book.gruppiANNOMODIFICA #qui stanno le frequenze di ogni valore
  riga =  "#{frequenzeANNOMODIFICA.inspect}"
  p riga
  pippo.scriviRiga(riga)
  # frequenzeANNOMODIFICA è un array che per elementi tante coppie kiave-valore (hash)
  # sia key che valore sono numeri interi; key indica il valore che caratterizza il gruppo
  # (-1 per i non assegnati, 2002, 2003 fino a 2015 per gli altri)
  
  # Visitiamo ciascun hash dell'array con la modalità chiavi-valori
  frequenzeANNOMODIFICA.each {|key, value| 
   	argomento = "annomodifica = #{key}"  # calcoliamo l'argomento del metodo where seguente
  	gruppo = Book.where(argomento).nobidoni #applichiamo lo scope nobidoni alla collezione di records
                                            #che hanno il valore di annomodifica uguale alla key dell'elemento
                                            #corrente di frequenzeANNOMODIFICA
                                            #ogni gruppo contiene una collezione di record di books 
                                            #che hanno lo stesso valore di annomodifica e NON sono Bidoni
  	lgruppo = gruppo.size   #numero di books non bidoni nel gruppo
  	riga = "gruppo con k(valore di annomodifica)=#{key} composto da #{lgruppo} books non bidoni."
	  pippo.scriviRiga(riga)
    # ci limitiamo al gruppo corrente e usiamo il value di key in frequenzeANNOMODIFICA e le dimensioni del
    # gruppo per incrementare nroTotali, nroBidoni e nroNoBidoni
    htotaliInBooks = bookOggetto.aggiungi(:tutti    , htotaliInBooks, value        )
    htotaliInBooks = bookOggetto.aggiungi(:bidoni   , htotaliInBooks, value-lgruppo)
    htotaliInBooks = bookOggetto.aggiungi(:nonbidoni, htotaliInBooks, lgruppo      )

    nro2016 = 0      #numero di volte che assegniamo il valore 2016, per il gruppo corrente
	  gruppo.each do |bookobj|
			 stringa = bookobj.url2
			 annohsh = bookobj.estraiAnnoDaUrl2(stringa)
			 if annohsh[:errore] == false && annohsh[:valore] == 2016
        # salviamo il record toccato
        bookobj.annomodifica = annohsh[:valore]
        bookobj.save
        #
				nro2016 += 1
			 else
          # si arriva in questo punto quando la applicazine di url2 o porta a un errore
          # oppure non si ha errore ma il risultato NON è 2016
			 end
    end # gruppo.each do |bookobj|
    #
		riga = "gruppo con kiave #{key}, n.ro sostituzioni: #{nro2016}."
		pippo.scriviRiga(riga) #p riga	
    # utilizziamo l'hash htotaliInBooks per accumulare il numero di 2016 calcolati	per il gruppo corrente
    bookOggetto.aggiungi(:sostituzioni2016, htotaliInBooks, nro2016)
    rigarisultati = "risult intermedi dopo gruppo con key= #{key}= #{htotaliInBooks[:sostituzioni2016]}"
    pippo.scriviRiga(rigarisultati)
  } # frequenzeANNOMODIFICA.each {|key, value|

  riga = "Ecco tutti contenuti finali del nostro hash locale: #{htotaliInBooks.inspect}"
  p riga
  pippo.scriviRiga(riga)
  # al termine del lavoro di ricalcolo con modifica, ricalcoliamo le frequenze dei valori del campo modificato
  riga = "RICALCOLO FREQUENZE sulla tabella DOPO LE MODIFICHE:"
  p riga
  pippo.scriviRiga(riga)
  #
  frequenzeANNOMODIFICA = Book.gruppiANNOMODIFICA #qui stanno le frequenze di ogni valore
  riga =  "#{frequenzeANNOMODIFICA.inspect}"
  p riga
  pippo.scriviRiga(riga)
  #
  pippo.scriviRiga("Risultati end#") 
  pippo.fineJob
end # stampaSorgente
