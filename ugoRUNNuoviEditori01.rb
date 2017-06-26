#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"
mioScript = "ugoRUNNuoviEditori01.rb"
pippo = Konta.new("#{mioScript} - 2016: confronto lpublishers/publishers -2017","0")

pippo.scriviRiga("Risultati start#")
pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}; prova: èòìàéù")

riscontriARR = []   # contiene le chiavi dei rec. di lpublishers che hanno riscontro in publ.
# STEP 1: tutto il contenuto di lpublishers deve trovarsi in publishers
pippo.scriviRiga("===Inizio STEP1: da lpublishers a publishers ===")
lparray = Lpublisher.all
pippo.scriviRiga("=== records in lpublishers: #{lparray.size}")
lparray.each{|lpobj|
	klpub = lpobj.ID_EDITORE
	nlpub = lpobj.Nome.downcase
	# accediamo alla tabella publishers e cerchiamo il record che ha per id il valore di klpub
	# poi estraiamo il suo nome, in npub, dove lo memorizziamo in tutte minuscole
	pobj = Publisher.find(klpub)
	npub = pobj.nome.downcase
	# confrontiamo le due stringhe nlpub e npub
	if nlpub == npub
    else
	   puts "== #{klpub} -- #{nlpub} -> #{npub}"	
    end
    #
    riscontriARR << klpub  # vengono contati come riscontri anche i 4 non proprio completi
}
pippo.scriviRiga("===Fine STEP1: da lpublishers a publishers =====")

# STEP 2: calcolo degli indici dei bidoni in publishers e attraversamento del loro insieme
pippo.scriviRiga("===Inizio STEP2: verifica bidoni in publishers ===")
quantiPublisher = Publisher.all.size
tuttiRANGE = Range.new(1, quantiPublisher)
tuttiARR = tuttiRANGE.to_a
bidoniARR = tuttiARR - riscontriARR
iconta = 0
bidoniARR.each{|idbid| 
	iconta += 1
	pobj = Publisher.find(idbid)
	puts "===#{iconta}    #{pobj.vecchioid}: #{pobj.nome}"
}
pippo.scriviRiga("===Fine STEP2: verifica bidoni in publishers =====")

pippo.scriviRiga("Risultati end#")
pippo.fineJob