#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"

require "./ugoLib/tuttoTravasa0.rb"
require "./ugoLib/controlloAliquotaIva.rb"

#NPUBLISHERS_2014 = 977
NPUBLISHERS_2015 = Lpublisher.maximum(:ID_EDITORE) # mantengo _2015, ma questa istruzione è ora UNIVERSALE

mioScript = "ugoRUNTravasa00.rb"
intestazione = "#{mioScript} - 6Nov.2016(17agoso17): 1-2000 documentazione a AI1619-2e"
puts intestazione
#exit
#pippo = Konta.new("#{mioScript} - 18 ott.Mo: prove lbooks->books con modif a script + CAI + tuttoTravasa","0")
#pippo = Konta.new("#{mioScript} - 8 sett 2015: prova trasferimento lbooks->books con modif a script + CAI + tuttoTravasa","0")
#pippo = Konta.new("#{mioScript} - 13 ott.15: prova likeat; completamento travaso.","0")
pippo = Konta.new(intestazione,"0")

#puts "packaging prova due: #{ControlloAliquotaIva::COSTANTI.inspect}"


miaProvetta = Provetta.new("1234", 13.45)
puts "Il primo campo dell'oggetto Provetta vale: #{miaProvetta.isbn}."
#miaProvetta.consoleInput
#miaProvetta.consoleInputNascosto

def creaIndice(pippo)
  # legge tutti i record che stanno in lbooks e ne ricava un hash (mioh)
  # nel quale la chiave è c01_vecchioid e il contenuto è l'id in lbooks.
  # Teniamo presente che lo stadio centrale di ugoRUNTravasa00.rb è uno scorrimento su tutti
  # i record bidone di books. Ciascuno di questi record ha un id (e un vecchioid=id) che vanno 
  # da 1 a   12241 (nel 2015). 
  #Per ogni record di books si ha bisogno si sapere:
  #     se esiste in lbooks un record che ha come c01_vecchioid il valore corrente di id in books
  #     in caso negativo quel record di books rimane come 'buco'
  #     in caso affermativo si vuole accedere al record di lbook che ha questo valore di id come
  #     contenuto di c01_vecchioid: per accedere a lbooks si userà una Lbook.find(numero).
  #     il valore di numero si ricava ricorrendo all'array di hash mioh, numero=mioh[id].
  # nota 2015: basterebbe creare un indice sul campo di lbooks che contiene vecchioid
  lb = Lbook.all
  lbSize = lb.size
  pippo.scriviRiga(" elementi in Lb: #{lbSize}")

  tiniziale = Time.new.to_f
  puts tiniziale  
  mioh = {1 => ''}
  h2 = Hash.new
  iii = 0
  lb.each{|lbo|
      
    h2 = {lbo.c01_vecchioid => lbo.id}
    mioh.merge!(h2)
    
    iii += 1  
    #break if iii == 5000
  }
  tfinale1 = Time.new.to_f
  puts tfinale1
  deltat1 = tfinale1 - tiniziale
  riga = sprintf("Secondi per la costruzione dell'hash: %6.4f",deltat1)
  puts riga
  pippo.scriviRiga(riga)
  # controllo mioh: scrivo primo e ultimo elemento.
  sizemioh = mioh.size
  primo_mioh = mioh[1]
  ultim_mioh = mioh[sizemioh]
  riga = "sizemioh: #{sizemioh}; primo: #{primo_mioh.inspect}; ultimo: #{ultim_mioh.inspect}"
  puts riga
  pippo.scriviRiga(riga)
  # un controllo più interessante è il seguente (introdotto nel 2015 
  # per la preparazione di Inventario2014):
  # scorrere tutto l'array di hash di nome mioh e trovare il valore più alto della chiave
  max_chiave = -1
  mio_valore = -1
  mioh.each do |chiave, valore|
    if chiave > max_chiave
      max_chiave = chiave
      mio_valore = valore
    end
  end
  # ora conosco max_chiave e mio_valore e li stampo
  riga = "la chiave più alta trovata vale: #{max_chiave} e ha come valore: #{mio_valore}"
  puts riga
  pippo.scriviRiga(riga)
  riga = "Quando nella scansione progressiva di books ci imbatteremo nel record con id #{max_chiave},"
  riga = riga + " dovremo prendere da lbooks il record con id= #{mio_valore}."
  puts riga
  pippo.scriviRiga(riga)
  #pippo.scriviRiga("#{mioh.inspect}")
  return mioh
end #def creaIndice()

# i seguenti due metodi sono stati inseriti qui
# in quanto il secondo (pincoPalla) non sono riuscito da Rails
# a farlo funzionare dall'interno della classe ControllaIdAliquotaIva
       def lista_formattata_errati(lista)
        # lista è un array di oggetti di tipo lbook raccolti dalla classe ControlloAliquotaIva
        # scopo di questo metodo è di costruire una lista formattata avente in ogni riga alcuni
        # elementi degli oggetti lbook contenuti in lista
          intesta = "--id-|-vid-|---tit-------- |d|co|-prez-|-aedi|----isbn-------|iva"    
           
          lista_f = []
          lista_f << intesta
          lista.each{|rec|
            depo = "#{rec.c09_deposito.inspect[0,1]}"   # solo f(alse) oppure t(rue) come string
            copie = pincoPalla(rec.c08_copie,2)
            idali = pincoPalla(rec.c14_idaliquotaiva,3)
            annoe = pincoPalla(rec.c12_ANNOEDIZIONE,4)
            prezz = pincoPalla(rec.c03_prezzoeurodec,5)
            riga = sprintf("%<x1>05d %<x2>05d %<x3>15.15s %<x4>1.1s %<x5>2.2s %<x6>6.6s %<x7>5.5s %<x8>15.15s %<x9>3.3s",
                            x1: rec.id               ,x2: rec.c01_vecchioid,x3: rec.c02_titolo,
                            x4: depo                 ,x5: copie            ,x6: prezz,
                            x7: annoe                ,x8: rec.c07_ISBN     ,x9: idali)
            lista_f << riga
          }
          return lista_f
       end   #def lista_formattata_errati()

       def pincoPalla(campo, caratteri = 5)
        # considera il campo passato in argomento e produce in output, sempre, una stringa su caratteri colonne
        # se campo è un int lo trasforma in stringa; se il campo è una stringa la lascia tal quale;
        # se il campo è nil restituisce  '0-'
        # il secondo argomento, opzionale, indica la lunghezza della stringa restituita
        base = "*" * caratteri   # uso l'operatore * definito per le stringhe
        if campo.nil?
          risult =  "0-" + base
          return risult[0,caratteri]
        else
          case 
           when campo.instance_of?(Fixnum)
            stri = campo.to_s
            risult = base + stri
            return risult[-caratteri,caratteri]
           when campo.instance_of?(String)
            risult = base + campo
            return risult[-5,caratteri]
           else
            return campo"??"            
          end # case
        end #campo.nil?
       end  #def converti_nil_a_stringa()   

# 2015: metodo per il controllo degli exit:
def do_at_exit(str1)
   at_exit { print str1 }
end


# =======================================================================
stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")

  # 1. creazione dell'indice per l'accesso rapido a lbook 
  mioh = creaIndice(pippo)
  #
  exit_mess1 = "blocco1: creato mioh."
  at_exit { puts exit_mess1 }

  # 2. la variabile stat, una volta locale, è diventata una variabile locale interna alla class, 
  #    con lo stesso nome.
  #stat = travasaobj.statistiche

  # 3. definiamo certi range usati da travasaDiretto
  publiRange = Range.new(1,NPUBLISHERS_2015)   # il range degli id per i publishers, aggiornato nome e suo calcolo automatico
  tipoORange = Range.new(1,19)    # un range possibile per id_tipoopera
  #    e li passiamo al metodo initialize, insieme al riferimento a pippo
  travasaobj = Travasa.new(publiRange, tipoORange, pippo)
  riga = "contenuto iniziale di @statistiche: #{travasaobj.statistiche.inspect}. -- ottenuto nel main grazie all'attr_reader statistiche."
  pippo.scriviRiga(riga)

  exit_mess3 = "blocco3: inizializzate statistiche."
  at_exit { puts exit_mess3 }
  #exit

  # 4. fissiamo i limiti del loop sugli elementi della tabella books
  chiaveMinima  =  12001 #9001 #11001 #5001 #11850 #10001 #11850 #5001  #1 # 0630 #9001 #7501 #6001 #4976 #3974
  chiaveMassima = 12698 #10000 #12241 #10000 #10001 #11851 #11440 #5000 #631 #9010 #11031 #9000 #7500 #4975 #3973
  chiaviRange = Range.new(chiaveMinima, chiaveMassima)
  riga = "Range per chiavi (vecchioid): #{chiaviRange.inspect}"
  puts riga
  pippo.scriviRiga(riga)

  exit_mess4 = "blocco4: inizializzate variabili del loop principale."
  at_exit { puts exit_mess4 }
  do_at_exit( "exit prima del loop operativo" )
  #exit  
  #
  # 5. loop operativo

  # ora possiamo scorrere la tabella books ed estrarre da mioh gli id corrispondenti al valore
  # dei campi vecchioid della tabella books
  miacondizione = "id >= #{chiaveMinima} and id <= #{chiaveMassima}"
  #miacondizione = "id >=1 and id <= 1000" #== 478  or id==546 or id==8242 or id==10694"
  # 08/10/2014 miacondizione = "id == 4295 or id==8241 or id==8242 or id==10694"  
  #miacondizione = "id == 4295 or id==8241 or id==8242 or id==10694 or id == 11365 or id == 1 or id==2 or id==3"  
  #miacondizione = "id >= 10001 and id <= 10010"
  ###exit if pippo.cnslLeggi("condizione='#{miacondizione}'; Vuoi INTERROMPERE? (Ss/Nn..)").upcase == "S"
  bb=Book.where(miacondizione)
  # la istruzione seguente è del tutto inutile: la scelta dei record di books è già stata fatta nella
  # precedente istruzione, che abbiamo sostituito al posto della bb = Book.All
  #
  # la istruzione seguente è mantenuta per memoria del metodo (class Array) select!, ma NON
  # può essere applicata se bb ....?
  #bb = bb.select!{|element| chiaviRange === element.id}   #17 marzo 2014
  #
  bbSize = bb.size
  riga = "Condizione cui devono soddisfare gli el. di books in cui travasare: #{miacondizione}"
  pippo.scriviRiga(riga)
  riga = "Elementi di books che soddisfano la condizione: #{bbSize}"
  pippo.scriviRiga(riga)
  ntrovati = 0
  nontrovati = 0
  ntravasati = 0
  nelaborati = 0

  carInPagina = 0

  #problemiArray = []  # 18/10/2016 viene costruito come variabile della classe Travasa

  bb.each{|bbo|
    
    chiave = bbo.vecchioid
     if mioh.has_key?(chiave)
      idDiVecchioID = mioh[chiave]
      # accediamo alla tabella lbooks posizionandoci sul suo record che
      # possiede un valore di vecchioid corrispondente all'id del record corrente di book
      lbo = Lbook.find(idDiVecchioID)
      # verifichiamo che l'id dal quale sono partito (chiave) è in generale diversa dall'id
      # che ho ottenuto con la find, mentre i due valori di vecchioid sono gli stessi
      if lbo.c01_vecchioid == bbo.vecchioid

        # attenzione in travasaDiretto fatte modif. per intrappolare record con problemi 18/10/2016
        travasaobj.travasaDiretto(bbo,lbo)              

        ntravasati +=1
      else #lbo.c01_vecchioid == bbo.vecchioid: non viene eseguito nessun travaso
        putc '@'
      end  
      ntrovati += 1
      putc '+' 
     else  #mioh.has_key?(chiave): il record di book che vogliamo riempire non esiste in lbook
      nontrovati += 1
      putc '-'
     end  #mioh.has_key?(chiave)
    nelaborati += 1
    #
    carInPagina += 1
    if carInPagina > 350
      puts "#{nelaborati}"
      carInPagina = 0
    end
  }

  # gestione finale tracciamento problemi 18/10/2016
  problemiArray = Travasa.getCampiProblematici()
  puts "\n\nproblemiArray: dimensioni #{problemiArray.size}. (vedi outrunner2.txt)"
  kont=0
  problemiArray.each {|problema| 
    kont +=1
    riga = "#{sprintf("%04d",kont)} #{problema}"
    pippo.scriviRiga(riga)
  }
  
   

  riga = "\nnelaborati: #{nelaborati}\n"
  puts riga
  riga = "elaborati:#{nelaborati}; trovati:#{ntrovati}; NON trovati:#{nontrovati}; "
  riga += "travasati:#{ntravasati}."
  pippo.scriviRiga(riga)  
  campi = [:id,           :titolo,        :prezzoeurodec, :isbn,       :copie, :deposito, 
           :publisher_id, :idtipoopera,   :annoedizione,  :idaliquotaiva,
           :url2,         :annomodifica ]
  campi.each{|simbolo|
    riga = "statistiche #{simbolo}: #{travasaobj.statistiche[simbolo].inspect}"
    puts riga 
    pippo.scriviRiga(riga)
  }

  lista_e = ControlloAliquotaIva.get_elenco_errati()

  pippo.scriviRiga("Oggetti trattati da CAI: #{ControlloAliquotaIva.get_quanti_records()}")
  pippo.scriviRiga("Oggetti con idALIVA originario non consentito: #{lista_e.size}")
  pippo.scriviRiga("elenco id memorizzati da CAI: #{lista_e.inspect}")
  lista_f = lista_formattata_errati(lista_e)
  lista_f.each do |miariga|
     pippo.scriviRiga(miariga) 
  end

  #6. blocco di chiusura - prova elencoBidoni
  # presuppone che nel Book model sia definito uno scope di nome bidoni, senza parametri (2016)
  elenco_bidoni = Book.bidoni
  quanti_bidoni = elenco_bidoni.size
  riga = "Al termine di questa elaborazione sono presenti in books"
  riga += " precisamente #{quanti_bidoni} record bidone."
  pippo.scriviRiga(riga)


  pippo.scriviRiga("Risultati end#")
  
end # stampaSorgente
pippo.fineJob
exit
