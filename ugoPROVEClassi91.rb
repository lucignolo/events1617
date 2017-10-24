#!/usr/local/bin/ruby
# (enkoding: WINDOWS-1252)
require "./ugorunnerXUtil (2).rb"

mioScript = "ugoPROVEClassi91.rb"
#pippo = Konta.new("#{mioScript} - 26ott 14 - modifiche per Iva=22","0")
pippo = Konta.new("#{mioScript} - 26ott 15 - (7 ottobre 2017-provazero)","0")
require "./libTitolo0.rb"
require 'logger'

require './ugolib/creaSuperHash2.rb'


class Inventario
CAPOR = " =Inv= "
SPZ = " "
TIPORIGA =  Hash[:intestazioneSup1, 1,
                 :intestazioneSup2, 2,
                 :standard, 3,
                 :intestazioneBlocco, 4,
                 :LibroPrimaRiga, 5,
                 :LibroSecondaRiga, 6,
                 :IntestazioneEditore, 7,
                 :SegnalazioneErrori, 8,
                 :TotaliEditore, 9,
                 :TotaliInventario, 10,
                 :intestazioneBlocco2, 11,
                 :intestazioneBlocco3,12] #  modificata il 17/10/2013

QUANTIEDITORI = Publisher.count #977 # per Inventario 2014; 952 #600 #921 #3 #921 #50 #3 #100  # numero di editori che compongono la lista Editori iniziale

@@SeparaColonne = "  "    # ".."   #21/10/2013


DATIFORMAT = Hash[:righePerPagina, 75,
                  :spazioInterColonne, 2,
                  :colonne, Hash[:vID,  Hash[:larghezza,  6, :formato, "%06<vID>i"],
                                 :ti1, Hash[:larghezza, 50, :formato, "%-50<ti1>s"]
                                ]
                 ]
  
  def initialize(intesta, log, pippo)
    # memorizziamo l'oggetto log come variabile di classe
    @@log = Logger::new(STDOUT)
    @@log.datetime_format="%H:%M:%S"
    @@log.level=Logger::DEBUG

    #idem facciamo per l'oggetto pippo: tutto quanto dipende da questa
    #classe  potrà utilizzare @@pip perchè il risultato finisca sul file outrunner2.txt
    @@pip = pippo

    # chiama il metodo creaSuperHash2 per definire una variabile @@attriBEF
    # (di classe)
    @@attriBEF = creaSuperHash2()
    @@pip.scriviRiga("#{@@attriBEF.inspect}")
    
    # imposta le variabili di classe
    #   @@conteggi          per la frequenza dei tipi riga
    #                       un Hash con almeno tante chiavi
    #                       quanti sono gli elementi di TIPORIGA
    #   @@totaliEditore     totali a livello di ciascun  editore
    #   @@totaliInventarioa totali a livello dell'intero Inventario
    #   @@statistiche
    creaConteggiAccumuliStatistiche()

    @@righe = [] #immaginiamo un array di array oppure di stringhe vuoto
    aggiungi_a_righe(:intestazioneSup1, intesta)
    girato = Time.now.strftime(".Elaborazione del %d %m %Y alle %I:%M%P") 
    aggiungi_a_righe(:intestazioneSup2, girato)

    #crea un hash di comunicazione per il controllo del Libro corrente
    @@controlloLibroCorrente = {:filtropassato => true, :errori => []}
    #@@log.info("controlloLibroCorrente: #{@@controlloLibroCorrente.inspect}")

    # crea l'hash dei conteggi per il singolo Editore
    #@@totaliEditore = creaTotaliEditore() ricompreso in creaConteggiAccumuliStatistiche
    
    

    # ora cominciamo la creazione dell'inventario creando 3 blocchi di editori
    #('A'..'C').each {|lettera|  faiBlocco(lettera)} sistemato in costruisci


    # definisce il file di output (nome ourunner3.txt) per le righe in @@righe prodotto da stampa_righe
    @@f_righe = File.new("outrunner3.txt", "w")
  end

  def costruisci()       #proviene da RUNI il 26/07/2013
                         #tolgo l'argomento pippo, in quanto
                         #si userà la variabile di classe @@pip
    listaOrdinata = Publisher.order('nome')
    #
    lettere = ('A'..'B')   #('A'..'Z')  modificato in provazero 2017
    lettere.each{|l| 
      questoBlocco = BloccoEditori.new(listaOrdinata,  l )   #, self, pippo)    
      putc l
    } # lettere.each
    aggiungi_a_righe("fine costruisci inventario")
  end #costruisci 
  
  def aggiungi_a_righe(tipo=:standard,riga)
    @@righe <<  sprintf("=%02d",TIPORIGA[tipo]) + SPZ + riga  # correzione del 11/09 e del 15/10/2013
    aggiornaConteggi(tipo)
  end #aggiungi a righe

  def stampa_righe
    questariga = "\nrighe totali presenti nell'Inventario: #{@@righe.size}."
    @@f_righe.write(questariga+"\n")
    @@righe.each do|r| 
      miotipo = r[0,2].to_i # correzione del 11/09/2013
      #puts r #if miotipo == TIPORIGA[:LibroPrimaRiga] || miotipo == TIPORIGA[:SegnalazioneErrori]
      @@f_righe.write(r+"\n")
     end #.each do
     @@f_righe.close
  end #stampa_righe  

  def creaConteggiAccumuliStatistiche
    @@conteggi = creaConteggi()
    @@totaliEditore = creaTotaliEditore()
    @@totaliInventario = creaTotaliInventario()
    @@statistiche = creaStatistiche()
    puts "-.-.-.-.#{@@statistiche.inspect}-.-.-.-."
  end #def creaConteggiAccumuliStatistiche  
  
  def creaConteggi
    localHash  =Hash[:intestazioneSup1, 0,
                     :intestazioneSup2, 0,
                     :standard, 0,
                     :intestazioneBlocco, 0,
                     :LibroPrimaRiga, 0,
                     :LibroSecondaRiga, 0,
                     :IntestazioneEditore, 0,
                     :SegnalazioneErrori, 0,
                     :TotaliEditore, 0,
                     :TotaliInventario, 0,
                     :intestazioneBlocco2, 0,
                     :intestazioneBlocco3, 0] #  modificato il 17/10/2013 
  end #creaConteggi

  def aggiornaConteggi(tipo)
    #@@log.debug("tipo: #{tipo.inspect}--#{@@conteggi[tipo].inspect}")
    @@conteggi[tipo] += 1
  end #aggiornaConteggi

  def stampaConteggi
    puts "\n\nConteggio tipi:\n" 
    @@pip.scriviRiga("Conteggio tipi:")   
    @@conteggi.each_pair{|k,v| 
      riga =  "tipo: #{k.to_s},  conteggio: #{v}"
      puts riga
      @@pip.scriviRiga(riga)
    } #.each_pair
  end  #stampaConteggi
  
  def faiBlocco(lettera)
    blocco = BloccoEditori.new(lettera)
  end #faiBlocco

  def resetCLC
=begin
  Assegna valori default agli elementi della variabile di classe
  @@controlloLibroCorrente.
  E' utilizzato dalla classe UnLibro all'inizio di ogni libro
=end    
    @@controlloLibroCorrente[:filtropassato]  = true
    @@controlloLibroCorrente[:errori] = []
  end #def resetCLC

  def creaTotaliEditore()
=begin
crea e restituisce un Hash contenente gli elementi per l'accumulo dei dati
per un singolo editore. Il nome che verrà dato a tale struttura dati è
@@totaliEditore. Verrà inizializzato all'inizio della elab. di ogni libro.
Verrà aggiornato dalla classe UnLibro e stampato dal metodo .... della classe
UnLibro. Il suo contenuto servirà per l'accumulo nella corrispondente struttura
definita a livello di Inventario (@@totaliInventario) a cura del metodo 
totaliEditoreStop
=end  
    localHash = Hash[:nLibri, 0,
                     :nCopie, 0,
                     :prezzoTCI, 0.0,
                     :prezzoTSI, 0.0]                 
  end #def creaTotaliEditore

  def creaTotaliInventario()
=begin rdoc
Definisce un hash per statistiche complessive sull'inventario
modificato, con aggiunta di due nuove voci, il 15/09/2013
=end
    localHash = Hash[:nEditori, 0,
                     :nLibri, 0,
                     :nCopie, 0,
                     :prezzoTCI, 0.0,
                     :prezzoTSI, 0.0,
                     :sommaLibriDisponibiliPerEditori, 0,
                     :sommaLibriSelezionatiPerEditori, 0]                 
  end #def creaTotaliInventario

  def stampaTotaliInventario()
=begin
stampa il contenuto delle variabili di ccumulo per l'intero Inventario.
modificato il 15/09/2013
=end      
    riga = "Totali Generali"
    aggiungi_a_righe(:TotaliInventario, riga) 
    riga = "Editori: #{@@totaliInventario[:nEditori]} "
    riga +="Libri: #{@@totaliInventario[:nLibri]} "
    riga +="Copie: #{@@totaliInventario[:nCopie]} "
    pTCIFormattato = sprintf("%8.2f", @@totaliInventario[:prezzoTCI])
    pTSIFormattato = sprintf("%8.2f", @@totaliInventario[:prezzoTSI])
    riga += " prTCI: #{pTCIFormattato}, prTSI: #{pTSIFormattato} ."
    aggiungi_a_righe(:TotaliInventario, riga)
    #
    riga = "Quadrature:" 
    aggiungi_a_righe(:TotaliInventario, riga)

    nLibri = @@totaliInventario[:nLibri]
    nLibrif = nLibri.to_f
    nDisponibili = @@totaliInventario[:sommaLibriDisponibiliPerEditori]
    nDisponibilif = nDisponibili.to_f
    nSelezionati = @@totaliInventario[:sommaLibriSelezionatiPerEditori]
    nSelezionatif = nSelezionati.to_f

    percSelezionatiSuDisponibili = (nSelezionatif*100.0)/nDisponibilif
    percSelezionatiSuDisponibiliForm= sprintf("%6.2f", percSelezionatiSuDisponibili)

    riga = "sommaLibriDisponibiliPerEditori: #{@@totaliInventario[:sommaLibriDisponibiliPerEditori]}"
    aggiungi_a_righe(:TotaliInventario, riga)
    riga = "sommaLibriSelezionatiPerEditori: #{@@totaliInventario[:sommaLibriSelezionatiPerEditori]}"
    riga += ", percentuale su Disponibili: #{percSelezionatiSuDisponibiliForm};  (cfr. con Libri)"
    aggiungi_a_righe(:TotaliInventario, riga)
    #
    nScartati = @@totaliInventario[:sommaLibriDisponibiliPerEditori]-
                @@totaliInventario[:sommaLibriSelezionatiPerEditori]
    nScartatif = nScartati.to_f
    percScartatiSuDisponibili = (nScartatif*100.0)/nDisponibilif
    percScartatiSuDisponibiliForm= sprintf("%6.2f", percScartatiSuDisponibili)

    riga =  "Totale Libri scartati (diff. tra le precedenti): #{nScartati}"
    riga += ", percentuale su Disponibili: #{percScartatiSuDisponibiliForm}"                
    aggiungi_a_righe(:TotaliInventario, riga)

  end #def stampaTotaliInventario

def creaStatistiche()
    localHash = Hash[:id, Hash[:min, 20000, 
                               :max, 0,
                               :miaLambda,lambda{|sx| 
                                                    x = @@attriBEF[sx][:valore] 
                                                    localHash[sx][:min]=x if x<localHash[sx][:min]
                                                    localHash[sx][:max]=x if x>localHash[sx][:max]}
                              ], # chiude l'Hash con chiavi :min, :max: ;mialambda (valore di chiave :id)
                     :iva, Hash[:min, 0,
                                :max, 0,
                                :miaLambda,lambda{|sx| 
                                               x = @@attriBEF[sx][:valore]                                              
                                               localHash[sx][:min]=x if x<localHash[sx][:min]
                                               localHash[sx][:max]=x if x>localHash[sx][:max]},
                                :lambdaFreq,   lambda{|sx|
                                                   x = @@attriBEF[sx][:valore]
                                                   localHash[:ivafreq][x] +=1
                                                   }               
                               ],
                     :ivafreq, Hash[0,0,  4,0,  20,0,   22,0],
                     :copie  , Hash[:min, 100,
                                    :max, 0,
                                    :miaLambda, lambda{|sx| 
                                                    x = @@attriBEF[sx][:valore] 
                                                    localHash[sx][:min]=x if x<localHash[sx][:min]
                                                    localHash[sx][:max]=x if x>localHash[sx][:max]},
                                    :gruppi, Hash[:unoOdue,       Hash[:rango, (1..2),   :frequenza, 0],
                                                  :treOquattro,   Hash[:rango, (3..4),   :frequenza, 0],
                                                  :daCinqueADieci,Hash[:rango, (5..10),  :frequenza, 0],
                                                  :undiciEOltre  ,Hash[:rango, (11..100),:frequenza, 0] 
                                                 ], # chiude HAsh[:unoOdDue...] valore di chiave :gruppi
                                    :lambdaFreq, lambda{|sx| 
                                                        x = @@attriBEF[sx][:valore] 
                                                        localHash[sx][:gruppi].each_pair{ |key, hash2|
                                                        localHash[sx][:gruppi][key][:frequenza] +=1 if hash2[:rango].include?(x)} 
                                                        }                   
                                    ],  # chiude Hash con chiave :copie
                     :copiefreq, Hash[1,0,2,0,3,0],
                     :prezzoeurodec, Hash[:min, 1000.0,
                                          :max, 0.0,
                                          :miaLambda,lambda{|sx| 
                                                     x = @@attriBEF[sx][:valore] 
                                                     localHash[sx][:min]=x if x<localHash[sx][:min]
                                                     localHash[sx][:max]=x if x>localHash[sx][:max]},
                                          :gruppi, Hash[:daZeroanove99, Hash[:rango, (0.0..9.99),     :frequenza, 0],
                                                        :da10a19e99,    Hash[:rango, (10.0..19.99),   :frequenza, 0],
                                                        :da20a29e99,    Hash[:rango, (20.0..29.9),    :frequenza, 0],
                                                        :da30a50  ,     Hash[:rango, (30.0..50.00),   :frequenza, 0],
                                                        :da51a99e99,    Hash[:rango, (50.01..99.99),  :frequenza, 0],
                                                        :da100a500,     Hash[:rango, (100.00..500.00),:frequenza, 0] 
                                                ],
                                          :lambdaFreq, lambda{|sx| 
                                                        x = @@attriBEF[sx][:valore] 
                                                        localHash[sx][:gruppi].each_pair{ |key, hash2|
                                                        localHash[sx][:gruppi][key][:frequenza] +=1 if hash2[:rango].include?(x)} 
                                                        }             
                                   ] # questa parentesi chiude la def dell'Hash con chiave :prezzoeorodec
                    ] # questa parentesi chiude la definizione di tutto il superHash

end  #def creaStatistiche()
def eseguiStatistiche(simbolo)
  # esegue un conteggio statistico di tipo minimo/massimo
  # utilizza l'hash mioH e cerca la componente [simbolo][:miaLambda]
  # esesgue quest'ultima lambda passandole come parametro la chiave (symbol) dell'elemento
  #
  # tolgo il primo argomento (mioH) e lo pongo uguale a @@statistiche
  mioH = @@statistiche
  #
  mioH[simbolo][:miaLambda].call(simbolo)
  #@@pip.scriviRiga("simbolo: #{simbolo.to_s}: min=#{mioH[simbolo][:min]}, max=#{mioH[simbolo][:max]}.")
end #def eseguiStatistiche

def eseguiFrequenze(simbolo)
    mioH = @@statistiche
    mioH[simbolo][:lambdaFreq].call(simbolo)
end #eseguiFrequenze


def stampaFrequenze(simbolo) 
# modif 26ott 14
mioH = @@statistiche
totaleFrequenze = 0
#
@@pip.scriviRiga("Frequenze per #{simbolo.to_s}") 
if simbolo.to_s == "iva"
  mioH[:ivafreq].each_pair do |key,val|
    chiave = sprintf("%2.2s",key.to_s)
    riga = "  #{chiave}  frequenza: #{val}"
    @@pip.scriviRiga(riga)
    totaleFrequenze += val
  end #..each_pair 
  @@pip.scriviRiga(" Totale frequenze per #{simbolo.to_s}: #{totaleFrequenze}")
  return 0
end #if simbolo.to_s == "iva"
mioH[simbolo][:gruppi].each_pair do |  key, hash2 |
    riga = " #{key}, #{hash2[:rango].inspect}, frequenza: #{hash2[:frequenza]}"
    @@pip.scriviRiga(riga)
    totaleFrequenze += hash2[:frequenza]
end #each_pair do
@@pip.scriviRiga(" Totale frequenze per #{simbolo.to_s}: #{totaleFrequenze}")
#
end #def stampaFrequenze

def stampaStatistiche( simbolo)
  mioH = @@statistiche
  riga = "Statistiche per #{simbolo.to_s}; max:#{mioH[simbolo][:max]}, min:#{mioH[simbolo][:min]}"
  @@pip.scriviRiga(riga)
end #def stampaSatistiche( simbolo)


  
end #class Inventario ---------------------------------------------class Inventario END

class BloccoEditori < Inventario
  def initialize(listaOrdinata, letteraInizialeNome)
    condizione1 = "id <= #{QUANTIEDITORI} AND nome LIKE '#{letteraInizialeNome}%' AND nome NOT LIKE '%nonono%'"  
    listaValidi = listaOrdinata.where(condizione1)
    if listaValidi.size == 0
      riga = "Il bloc Edit relativo alla lettera #{letteraInizialeNome} NON CONTIENE Editori."
      aggiungi_a_righe(:intestazioneBlocco, riga )
      return false
    else # if listaValidi.size
      # modofiche del 17/10/2013
      riga1 = "Blocco Editori che hanno per iniziale la lettera"
      riga2 = "#{letteraInizialeNome}"
      riga3 = "( contiene #{listaValidi.size} Editori )"
      aggiungi_a_righe(:intestazioneBlocco,  riga1)
      aggiungi_a_righe(:intestazioneBlocco2, riga2)
      aggiungi_a_righe(:intestazioneBlocco3, riga3)

      #riga  = "Il bloc Edit relativo alla lettera #{letteraInizialeNome} CONTIENE"
      #riga += " #{listaValidi.size} Editori."
      #aggiungi_a_righe(:intestazioneBlocco, riga )
      #
      listaValidi.each{|pub| 
      gruppoBooks = pub.books
      quantiBooksLegati = gruppoBooks.size
      @@pip.scriviRiga("* -  #{pub.nome}- con #{quantiBooksLegati} books") 
      #
      faiEditore(pub)  #tratta un singolo editore nel blocco
      } #listavalidi.each
    end #if listaValidi  

=begin
    @@inizioBlocco = lettera
    @@quantiNelBlocco = 2   # numero di editori il cui nome comincia per lettera
    faiIntestazioneBlocco
    # ora il blocco viene composto a partire dall'elenco editori
    mioRange = Range.new(1, @@quantiNelBlocco)
    mioRange.each {|ele|
      aggiungi_a_righe(:IntestazioneEditore, "piccola intestazione a singolo editore (#{ele})")
      faiEditore(ele)
      }
=end      
  end #initialize
  
  def faiIntestazioneBlocco
    intBlocco = "Blocco Editori con nome che inizia per #{@@inizioBlocco}"
    aggiungi_a_righe(:intestazioneBlocco,intBlocco)
    intBlocco = "questo blocco contiene #{@@quantiNelBlocco} Editori"
    aggiungi_a_righe(:intestazioneBlocco,intBlocco)   
  end
  
  def faiEditoreVecchio(idEditore)
    editore = UnEditore.new(idEditore)    
  end #faiEditoreVecchio

  def faiEditore(pubobj)
    editore = UnEditore.new(pubobj)    
  end #def faiEditore

end # class BloccoEditori

class UnEditore < BloccoEditori
  def initialize(pubobj)
=begin
  Modifica del 03/08/2013 per filtrare i books appartenenti a un dato editore
=end
    totaliEditoreStart(pubobj)  #mette intestazione in @@righe e azzera conteggi
    mioGruppoBooks = pubobj.books
    condizioni = "deposito = 'f' AND copie > 0 AND prezzoeurodec > 0.0"
    gruppoBooks = mioGruppoBooks.where(condizioni)
    #
    nmioGruppoBooks = mioGruppoBooks.size
    ngruppoBooks = gruppoBooks.size
    @@totaliInventario[:sommaLibriDisponibiliPerEditori] += nmioGruppoBooks
    @@totaliInventario[:sommaLibriSelezionatiPerEditori] += ngruppoBooks
    #
    gruppoBooks.each{|libro|
      #intestazioneLibro = "...creo il libro #{libro.id} su un totale di #{gruppoBooks.size}"
      #aggiungi_a_righe(intestazioneLibro)
      faiLibro(libro)
      }  #gruppoBooks.each 
    totaliEditoreStop(pubobj)  # mette in @@righe i totali per l'editore        
  end
  def totaliEditoreStart(pubobj)
    # crea l'intestazione per l'editore pubobj
    riga = "Editore: #{pubobj.nome}."
    aggiungi_a_righe(:IntestazioneEditore, riga )
    # azzera le componenti dei totali
    @@totaliEditore[:nLibri] = 0
    @@totaliEditore[:nCopie] = 0
    @@totaliEditore[:prezzoTCI] = 0.0
    @@totaliEditore[:prezzoTSI] = 0.0
    # altre componenti da azzerare  
  end # def totaliEditoreStart

  def totaliEditoreStop(pubobj)
    # crea l'intestazione di chiusura per l'editore pubobj
    riga = "Totali per l'editore: #{pubobj.nome}."
    riga += " nLibri: #{@@totaliEditore[:nLibri]}, nCopie: #{@@totaliEditore[:nCopie]},"
    pTCIFormattato = sprintf("%8.2f", @@totaliEditore[:prezzoTCI])
    pTSIFormattato = sprintf("%8.2f", @@totaliEditore[:prezzoTSI])
    riga += " prTCI: #{pTCIFormattato}, prTSI: #{pTSIFormattato} ."
    aggiungi_a_righe(:TotaliEditore, riga )
    # accumula nell'hash totaliInventario i totali di questo Editore
    @@totaliInventario[:nEditori] += 1   
    @@totaliInventario[:nLibri] += @@totaliEditore[:nLibri]  
    @@totaliInventario[:nCopie] += @@totaliEditore[:nCopie] 
    @@totaliInventario[:prezzoTCI] += @@totaliEditore[:prezzoTCI]  
    @@totaliInventario[:prezzoTSI] += @@totaliEditore[:prezzoTSI]  

  end #def totaliEditoreStop

  def faiLibro(libobj)
    libro = UnLibro.new(libobj.id)
  end

end

class UnLibro < UnEditore
  def initialize(idLibro)
=begin
versione che accede a un libro in modo random e si appropria del suo id e del suo titolo
passa poi quest'ultimo a faiRighe
=end
    resetCLC()  # riporta al default gli elementi di @@controlloLibroCorrente
    #
    vecchioID = 1234
    titolo = "titolo del libro con vecchioID uguale a #{vecchioID}."
    #
    miorand = Random.new
    numeroACaso = miorand.rand((1..1447))
    
    questoBook = Book.find(idLibro)   #numeroACaso)
    #
    #---memorizza i valori degli attributi nel superHash, variabile di classe
    @@attriBEF[:id][:valore]            = questoBook.id
    @@attriBEF[:titolo][:valore]        = questoBook.titolo
    @@attriBEF[:vecchioid][:valore]     = questoBook.vecchioid
    @@attriBEF[:deposito][:valore]      = questoBook.deposito
    @@attriBEF[:copie][:valore]         = questoBook.copie
    @@attriBEF[:prezzoeurodec][:valore] = questoBook.prezzoeurodec
    @@attriBEF[:idaliquotaiva][:valore] = questoBook.idaliquotaiva
    @@attriBEF[:url2][:valore]          = questoBook.url2
    @@attriBEF[:annoedizione][:valore]  = questoBook.annoedizione   # 21/10/2013
    @@attriBEF[:annomodifica][:valore]  = questoBook.annomodifica   # 21/10/2013
    @@attriBEF[:isbn][:valore]          = questoBook.isbn           # 21/10/2013

    # qui il filtro per la congruenza con i requisiti dell'Inventario
    if filtro_zero()  #seleziona i libri con le seguenti caratteristiche:
                      # 0) non bidone
                      # 1) deposito=false
                      # 2) copie positivo

    # se il librosupera il filtro
    # si occupa degli altri campi ricavandoli dagli attributi
    # --1)-modifica qui l'idaliquotaIVA in IVA
    @@attriBEF[:iva][:valore] = daIDaIVA(@@attriBEF[:idaliquotaiva][:valore])

    # --2)-calcola il prezzo totale pieno (con iva)
    @@attriBEF[:prezzoTCI][:valore] = prezzoTCI()

    # --3)-calcola il prezzo totale senza iva
    @@attriBEF[:prezzoTSI][:valore]= prezzoTSI()

    # --4)-calcola la stringa con anno edizione, annomodifica e isbn
    # restituisce una stringa formattata pronta per l'uso insieme al format
    # definito anch'esso in @@attriBEF
    @@attriBEF[:edimodisb][:valore] = creaEdiModIsb()

    
    # elabora - si occupa del titolo
    @titolo = @@attriBEF[:titolo][:valore]
    @vecchioid = @@attriBEF[:id][:valore]

    righeTitolo = faiRighe(@@log, @titolo)
    quanteRighe = righeTitolo.size
    oggettoFormSprintf = FormSprintf.new()
    oggettoFormSprintf.formDumpa(@@attriBEF[:id][:valore], "righeTitolo.inspect",righeTitolo.inspect)
    @@log.debug("...#{@vecchioid}, #{@titolo}, #{quanteRighe}...")
    # memo in @@attriBEF la prima parte del titolo
    @@attriBEF[:titolo][:valore] = righeTitolo[0]


    # alla fine della eleb. scrive in ogni caso la prima riga completa formattata
    # facciamo in modo che pezfor1 diventi un metodo della classe FormSprintf
    format1 = FormSprintf.new
    primaRigaCF = format1.pezfor1
    aggiungi_a_righe(:LibroPrimaRiga, primaRigaCF )

    # nel caso esistano altre righe del titolo, va preparato un format particolare
    # per includere in esso il parametro @@SeparaColonne  var. del 21/10/2013
    if quanteRighe > 1
       form_1 = "%6.0<vID>i"
       form_2 = "  #{@@SeparaColonne}%-40.40<ti1>s"   # due blank prima della separazione di colonne
       form_mio = form_1 + form_2
    end   #quanteRighe > 1

    case quanteRighe
    when 1
            
    when 2
      #aggiungi_a_righe(:LibroSecondaRiga, sprintf("%6.0<vID>i ...%-40.40<ti1>s", vID: 0, ti1: righeTitolo[1]) )
      aggiungi_a_righe(:LibroSecondaRiga, sprintf(form_mio, vID: 0, ti1: righeTitolo[1]) )

    when 3
      aggiungi_a_righe(:LibroSecondaRiga, sprintf(form_mio, vID: 0, ti1: righeTitolo[1]) )
      aggiungi_a_righe(:LibroSecondaRiga, sprintf(form_mio, vID: 0, ti1: righeTitolo[2]) )

    when 4
      (1..3).each {|ii|
        aggiungi_a_righe(:LibroSecondaRiga, sprintf(form_mio, vID: 0, ti1: righeTitolo[ii]) )
      }
    else
      aggiungi_a_righe(:LibroPrimaRiga, sprintf(form_mio, vID: @vecchioid, ti1: "troppe righe") )
    end
    # aggiorna i contatori per l'Editore corrente
    @@totaliEditore[:nLibri] += 1
    @@totaliEditore[:nCopie] += @@attriBEF[:copie][:valore]
    @@totaliEditore[:prezzoTCI] += @@attriBEF[:prezzoTCI][:valore]
    @@totaliEditore[:prezzoTSI] += @@attriBEF[:prezzoTSI][:valore]

    # nel caso di libro filtrato ok esegue qui le prime statistiche
    eseguiStatistiche(:id)
    eseguiStatistiche(:copie)
    eseguiStatistiche(:prezzoeurodec)
    eseguiStatistiche(:iva)   # modifica 26ott 14
    # esegue frequenze sui gruppi (copie e prezzo)
    #valore = @@attriBEF[:copie][:valore]
    eseguiFrequenze(:copie)
    eseguiFrequenze(:prezzoeurodec)
    eseguiFrequenze(:iva)


  else #if !filtro_zero
    riga = "LIBRO #{@@attriBEF[:id][:valore]} SCARTATO: #{@@controlloLibroCorrente[:errori][0]}."
    aggiungi_a_righe(:SegnalazioneErrori, riga)
  end #if !filtro_zero



  end # def initialize

  def daIDaIVA(id)
    #converte un idaliquotaIVA nel valore dell'IVA
    #modifiche del 26 ottobre 2014 per consentire il valore 4 come indice (con iva=22)
    #                 e estensione di tale valore anche all'indice 2
    veraiva = Hash[ "1" => 4, "2" => 22, "3" => 0, "4" => 22]
    return -9 if !(1..4).include?(id.to_i)
    questaIVA = veraiva[id.to_s]
    #@@log.debug("::::::::::::daIDaIVA: #{id.inspect} -- #{veraiva.inspect}-- #{questaIVA}")
    return questaIVA
  end #def

  def prezzoTCI()
    # conteggia il valore derivato prezzoTCI da copie e prezzoeurodec
    ncopie = @@attriBEF[:copie][:valore]
    prezzoConIva = @@attriBEF[:prezzoeurodec][:valore]
    return prezzoConIva*ncopie
  end # prezzoTCI

  def prezzoTSI()
    miaIVA = @@attriBEF[:iva][:valore] 
    xfactor = (miaIVA+100.0)/100.0
    #@@log.debug("-----------xfactor: #{@@attriBEF[:iva][:valore]}...#{xfactor} -----")
    ncopie = @@attriBEF[:copie][:valore]
    prezzoConIva = @@attriBEF[:prezzoeurodec][:valore]
    prezzoTotaleSenzaIva = (prezzoConIva*ncopie)/xfactor
  end #def prezzoTSI

  def creaEdiModIsb()
  # versione  definitiva del 21/10/2013
  # concatena i risultati di tre distinti metodi paralleli con due
  # separazioni di colonne, che definisce in base alla variabile di classe Inventario   
  # 
    sepaCol = @@SeparaColonne
    stringaProva  = estraeAnnoEdizione()  # 5 car
    stringaProva += sepaCol               # 2 car
    stringaProva += estraeAnnoModifica()  # 5
    stringaProva += sepaCol               # 2
    stringaProva += estraeIsbn()          # 13 car totale 27
  end # def creaEdiModIsb()

  def estraeAnnoEdizione()
   ini = "e"
   annoNum = @@attriBEF[:annoedizione][:valore]
   if annoNum.nil?
    dopo = "?..."
    #pippo.scriviRiga("-#{annoNum}-#{dopo}")
   else #annuNum.nil?
    if annoNum > 10  
     dopo = sprintf("%4.4s", annoNum.to_s)
    else #  if annoNum > 10 
     dopo = "?..."
     #pippo.scriviRiga("-#{annoNum}-#{dopo}")
    end  #  if annoNum > 10 
   end  #annuNum.nil?
   annoForm = ini + dopo
  end #def estraeAnnoEdizione()

  def estraeAnnoModifica()
   ini = "m"
   annoNum = @@attriBEF[:annomodifica][:valore]
   if annoNum.nil?
    dopo = "?..."
    #pippo.scriviRiga("-#{annoNum}-#{dopo}")
   else #annuNum.nil?
    if annoNum > 10  
     dopo = sprintf("%4.4s", annoNum.to_s)
    else #  if annoNum > 10 
     dopo = "?..."
     #pippo.scriviRiga("-#{annoNum}-#{dopo}")
    end  #  if annoNum > 10 
   end  #annuNum.nil?
   annoForm = ini + dopo
  end #def estraeAnnoModifica()  

  def estraeIsbn()
   mioIsbn = @@attriBEF[:isbn][:valore]
   if mioIsbn.nil?
    dopo = "isbn?"
    #pippo.scriviRiga("-#{annoNum}-#{dopo}")
   else #mioIsbn.nil?
    mioIsbn2 = mioIsbn.strip 
    if mioIsbn2.size == 13  
     dopo = sprintf("%13.13s", mioIsbn2)
    else #  if mioIsbn.size == 13
      if mioIsbn2.size == 0
        dopo = "no isbn"
      else  # mioIsbn2.size == 0
         dopo = sprintf("(?)%-13.13s", mioIsbn2)
         #pippo.scriviRiga("-#{annoNum}-#{dopo}")
      end   # mioIsbn2.size == 0
    end  #  if mioIsbn.size == 13
   end  #annuNum.nil?
   isbnForm = dopo
  end #def estraeAnnoModifica()  

  def filtro_zero()
=begin
  esegue i controlli che consentono il passaggio ai libri che:
  1. non siano libri bidone
  2. abbiano l'attributo deposito = false (f)
  verifica che la cond0 sia verificata (libro NON BIDONE) e passa al secondo
  controllo (LIBRO CON DEPOSITO=FALSE)
=end 
  continua = false
  cond0 = !@@attriBEF[:titolo][:valore].upcase.include?('TITOLOBIDONE')
    if cond0
      continua = true
    else # cond0
      @@controlloLibroCorrente[:filtropassato]=false
      @@controlloLibroCorrente[:errori] << "Record BIDONE, non consentito"
      return false
    end # cond0
  if continua  
  continua = false
  cond1 = @@attriBEF[:deposito][:valore] == false
    #@@log.debug("------deposito: #{@@attriBEF[:deposito][:valore].inspect}")
    if cond1
      continua = true
    else # cond1
      @@controlloLibroCorrente[:filtropassato]=false
      @@controlloLibroCorrente[:errori] << "Deposito TRUE, non consentito"
      return false
    end #cond1
    if continua
      cond2 = @@attriBEF[:copie][:valore] > 0
      #@@log.debug("------deposito: #{@@attriBEF[:deposito][:valore].inspect}")
      if cond2
        return true
      else # cond2
        @@controlloLibroCorrente[:filtropassato]=false
        @@controlloLibroCorrente[:errori] << "COPIE !>0, non consentito"
        return false
    end #cond1      

    end #continua
  end # continua   
  end #def filtro_zero



end #class UnLibro

class FormSprintf < Inventario
  def initialize()
    #@@log.info("lunghezza della colonna tit1: #{DATIFORMAT[:colonne][:ti1][:larghezza]}")
  end
  def getForm(colonna)
    return DATIFORMAT[:colonne][colonna][:formato]
  end

  def pezfor1()
    valo = []  #[1234, "abcd efg", 123.56]
    form = []  #["%6i", "%-10s", "%7.2f"]
    campiElaborati = [] #conterrà le chiavi degli attributi inclusi nel formato
    @@attriBEF.each_pair do |chiave,altro|
      #puts "---------------#{chiave}, --#{altro.inspect}"
      if altro[:elabora]  
        valo << altro[:valore]
        form << altro[:formato]
        campiElaborati << chiave
      end #if
    end #each_pair
    questoid = @@attriBEF[:vecchioid][:valore]
    titolo = @@attriBEF[:titolo][:valore]
    formDumpa(questoid,"campiElaborati.inspect", campiElaborati.inspect)
    formDumpa(questoid,"form.inspect", form.inspect)
    formDumpa(questoid,"valo.inspect", valo.inspect)
    formDumpa(questoid,"titolo.size", titolo.size)
    #puts "campi elaborati: #{campiElaborati}"

    sup = valo.size-1
    mioRange = Range.new(0,sup)
    rigaFormattata = mioRange.inject(""){|ftem, i|
        #ftem = ftem + ".." + form[i]
        ftem = ftem + @@SeparaColonne + form[i]    #  21/10/2013
        risu = sprintf(ftem, valo[i])
        formDumpa(questoid, "ftem.inspect", ftem.inspect)
        #puts "#{i}: #{risu}"
        ftem = risu
    }
    formDumpa(questoid, "rigaFormattata", rigaFormattata)
    return rigaFormattata
  end #def pezfor1

  def formDumpa(bookid, spiega, valore)
    idSensibile = -1 #3282 #-1 #10793 #3265 #707
    if bookid == idSensibile
      si = "{{{ <#{bookid}> #{spiega}: "
      sf = "}}}\n"
      @@f_righe.write(si+"#{valore}"+sf)
    else #bookid
    end #bookid
  end #def formDumpa

end #class FormSprintf

# ============================================================================
stampaSorgente = false 
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else #stampasorgente
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")


#---aggiungiamo anche la classe Titolo presa da ugoPROVEtitolo0.rb
# la classe Titolo è contenuta nella libreria 'libTitolo0', per ora nella stessa cartella dello script
#---fine della classe Titolo

# main usiamo le classi da qui in avanti
# 1. inizializziamo il logger chiamandolo log e definiamo il formato del tempo in esso
#    richiesto. L'oggetto log è richiesto al momento dalla classe Titolo

# 2. inseriamo nel presente modulo un metodo di servizio che estrae tronconi da un titolo fisso
MASSIMA = 40 #50

def faiRighe(log, mioTitolo)   #---------------------------------- per semplificare
=begin
miotitolo = <<-FINE_DEL_TITOLO
Titolo del libro generico, volutamente lungo \
per consentire una divisione in cica due righe.
FINE_DEL_TITOLO
=end
questot = Titolo.new(mioTitolo, MASSIMA)
  if questot.spezza(mioTitolo,log)
    tronconi = questot.getTronconi
    return tronconi
    #puts "tronconi>>#{tronconi.inspect}"
  else
    puts "errore nel metodo spezza"
  end
end #def faiRighe   #----------------------------------- per semplificare  

log = Logger::new(STDOUT)
log.datetime_format="%H:%M:%S"
#
# 2. avviamo l'inventario
intestazione = "Libreria Accursio - Inventario 2015 - iva dal 20 al 22 - solo2 variazioni"
inventario2012 = Inventario.new(intestazione, log, pippo)
inventario2012.costruisci()
inventario2012.stampaTotaliInventario

inventario2012.stampa_righe

inventario2012.stampaConteggi
#
inventario2012.stampaStatistiche(:id)
inventario2012.stampaStatistiche(:copie)
inventario2012.stampaStatistiche(:prezzoeurodec)
inventario2012.stampaStatistiche(:iva)
#
inventario2012.stampaFrequenze(:copie)
inventario2012.stampaFrequenze(:prezzoeurodec)
inventario2012.stampaFrequenze(:iva)

pippo.scriviRiga("Risultati end#")

end # stampaSorgente
pippo.fineJob  

