#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

mioScript = "ugoRUNTRicalcolaANNOMODIFICA.rb"
intestazione = "#{mioScript} - 20/07/2017: in books, ricalcola annomodifica per AI16"
puts intestazione
pippo = Konta.new(intestazione,"0")

def mostraSpiegazioni()
spiega = <<END_OF_STRING
\nAccede in LETTURA e SCRITTURA alla tabella books, nella quale in ugoRUNTravasa00.rb, è stato commesso un errore nel calcolo di annomodifica. Ricalcola il valore di questo attribute e salva i record cambiati.

Il metodo usato per calcolare annomodifica partendo dall'attribute url2, è il metodo estraiAnnoDaUrl2, che si trova definito in book.rb.

END_OF_STRING
puts spiega
end #def mostraSpiegazioni 

def aggiungi(totaliInBooks, chiave, valoredaaggiungere=0, pippo=nil)
# totaliInBooks è un hash locale: con questo nome si fa riferimento all'hash che viene passato come primo argomento della chiamata
case 
  when chiave == :azzera
    # proviamo a usare la regola per il default degli hash (DThomas, p.21)
    totaliInBooks = Hash.new('123')  # quando si accede all'hash con una chiave non valida, risponde con '123'
    totaliInBooks.each_key {|mykey| totaliInBooks[mykey=>0]}
  when chiave == :stampa
    totaliInBooks.each_key {|mykey, myvalue| 
      riga = "#{mykey} contiene #{myvalue}"
      p riga
    }
else
  prima = totaliInBooks[chiave]
  dopo = prima + valoredaaggiungere
  totaliInBooks[chiave => dopo]
  p "ho aggiunto:#{totaliInBooks[chiave]} in #{chiave.inspect} --" 
end

end #def aggiungi(totaliInBooks, chiave, valoredaaggiungere, pippo)



stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")  
  pippo.scriviRiga("Ruby version: #{RUBY_VERSION}, PATCH LEVEL: #{RUBY_PATCHLEVEL}")
  #01. display spiegazioni a video
  mostraSpiegazioni()

  #02 definisce hash totaliInBooks e prova azzera e stampa
  htotaliInBooks = { tutti: 0, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0 }
  p "#{htotaliInBooks.inspect}"

  aggiungi(htotaliInBooks, :azzera)
  p "#{htotaliInBooks.inspect}"
  aggiungi(htotaliInBooks, :stampa,0,pippo)
  aggiungi(htotaliInBooks, :tutti, 234, pippo)
  aggiungi(htotaliInBooks, :stampa,0,pippo)
  
  #03 corpo della parte esecutiva
  # dividiamo la tabella in gruppi in base al valore attuale di annomodifica
  frequenzeANNOMODIFICA = Book.gruppiANNOMODIFICA #qui stanno le frequenze di ogni valore
  riga =  "#{frequenzeANNOMODIFICA.inspect}"
  p riga
  pippo.scriviRiga(riga)
  # frequenzeANNOMODIFICA è un array che per elementi tante coppie kiave-valore (hash)
  # sia key che valore sono numeri interi; key indica il valore che caratterizza il gruppo
  # (-1 per i non assegnati, 2002, 2003 fino a 2015 per gli altri)
  # Visitiamo l'array con la modalità chiavi-valori
  frequenzeANNOMODIFICA.each {|key, value| 
   	argomento = "annomodifica = #{key}"  # calcoliamo l'argomento del metodo where seguente
  	gruppo = Book.where(argomento).nobidoni #applichiamo lo scope nonbidoni a ogni gruppo
  	lgruppo = gruppo.size   #numero di books non bidoni nel gruppo
  	riga = "gruppo con k=#{key} composto da #{lgruppo} books non bidoni."
	pippo.scriviRiga(riga)
	# ora analizziamo i gruppi con valore assegnato che ci interessa
	if key == -1 || key == 2015
		# contiamo il numero di volte che otteniamo 2016 da url2
		nro2016 = 0
		gruppo.each do |bookobj|
			stringa = bookobj.url2
			annohsh = bookobj.estraiAnnoDaUrl2(stringa)
			if annohsh[:errore] == false && annohsh[:valore] == 2016
				nro2016 += 1
			else
			end
		end #gruppo.each do |libro|
		riga = "gruppo con kiave #{key}, n.ro sostituzioni: #{nro2016}."
		pippo.scriviRiga(riga) #p riga		
	else
	end
  } # frequenzeANNOMODIFICA.each {|key, value|
  exit

  INIZIO = 16   #Book.first.id
  FINE = INIZIO + 30
  (INIZIO..FINE).each do |idrec|  	
  	miorec = Book.find(idrec)
  	if miorec.annomodifica == -1
  		stringa = miorec.url2
  		prova = miorec.estraiAnnoDaUrl2(stringa)
  		p "url2: #{stringa}"
  		p "errore: #{prova[:errore].inspect}"
  		p "valore: #{prova[:valore].inspect}"
  		riga = miorec.id.to_s + "  " + stringa + " " +  prova[:errore].to_s + " " +  prova[:valore].to_s
  		pippo.scriviRiga(riga)
  	else
  	end

  end  
  pippo.scriviRiga("Risultati end#")  

end # stampaSorgente
pippo.fineJob
