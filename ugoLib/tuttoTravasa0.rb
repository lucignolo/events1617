# file: tuttoTravasa0.rb
# contiene class Travasa e nuova class ControlloAliquotaIva
# 29/07/2014
require "./ugoLib/controlloAliquotaIva.rb"
  class Travasa
    attr_reader :statistiche

    @@consoleTravasa = nil
    def initialize(publiRang, tipoORang, pipp)
      @statistiche = creaStatistiche()
      @publiRange  = publiRang
      @tipoORange  = tipoORang
      @pippo       = pipp
      # prove d'uso della class ControlloAliquotaIva
      @pippo.scriviRiga("::: COSTANTI class ControlloAliquotaIva [:id_ammessi ]: #{ControlloAliquotaIva::COSTANTI[:id_ammessi].inspect} :::")
      @pippo.scriviRiga("::: COSTANTI class ControlloAliquotaIva [:casi        ]: #{ControlloAliquotaIva::COSTANTI[:casi].inspect} :::")
      # altre prove:
      @idivaRange = ControlloAliquotaIva::COSTANTI[:id_ammessi]

      # modifiche 2015(nel 2016) per intrappolare record con problemi
      @@arrayCampiProblematici = []           #18/10/2016
      @@lbooksIDCorrFormattato = "00345"      #18/10/2016

      # definisce un oggetto della classe Provetta per potere utilizzare i metodi di interazione
      if @@consoleTravasa.nil?
        @@consoleTravasa = Provetta.new("123", 123.4)
      end #if @@consoleTravasa.nil?
    end #def initialize

    def travasaDiretto(bbo, lbo)
      @@lbooksIDCorrFormattato = sprintf("%05d", lbo.c01_vecchioid)   #21/10/2016
      #
#  travasa alcuni campi da lbo (istanza di LBook) a bbo (istanza di Book)
      # titolo (c02) ----------------------------------------------------------------------------
      sorgente  = tra_titolo(lbo)
      if sorgente == false
        segnalaProblema("titolo")
      else
        bbo.titolo = sorgente
        bbo.save
      end 

      # prezzoeurodec (c03) ----------------------------------------------------------------------------
      sorgente  = tra_prezzoeurodec(lbo)
      if sorgente == false
        segnalaProblema("prezzoeurodec")
      else
        bbo.prezzoeurodec = sorgente
        bbo.save
      end 

      # isbn (c07) ----------------------------------------------------------------------------
      sorgente  = tra_isbn(lbo)
      if sorgente == false
        segnalaProblema("isbn")
      else
        bbo.isbn = sorgente
        bbo.save
      end 

      # copie (c08) ----------------------------------------------------------------------------
      sorgente  = tra_copie(lbo)
      if sorgente == false
        segnalaProblema("copie")
      else
        bbo.copie = sorgente
        bbo.save
      end 

      # deposito (c09) ----------------------------------------------------------------------------
      sorgente  = tra_deposito(lbo)
      bbo.deposito = sorgente
      bbo.save

      # publisher_id (c10) ----------------------------------------------------------------------------
      sorgente  = tra_publisher_id(lbo)
      if sorgente == false
        segnalaProblema("publisher_id")
      else
        bbo.publisher_id = sorgente
        bbo.save
      end     


      # IDTIPOOPERA (c11) ----------------------------------------------------------------------------
      sorgente  = tra_idtipoopera(lbo)
      if sorgente == false
        segnalaProblema("IDTIPOOPERA")
      else
        bbo.idtipoopera = sorgente
        bbo.save
      end     

      # annoedizione (c13) ----------------------------------------------------------------------------
      sorgente  = tra_annoedizione(lbo)
      if sorgente == false
        segnalaProblema("annoedizione")
      else
        bbo.annoedizione = sorgente
        bbo.save
      end      
 
     # idaliquotaiva (c14) ----------------------------------------------------------------------------
      sorgente  = tra_idaliquotaiva(lbo)
      if sorgente == false
        segnalaProblema("idaliquotaiva")
      else
        bbo.idaliquotaiva = sorgente
        bbo.save
      end        

      # url2 (c15) ----------------------------------------------------------------------------
      sorgente  = tra_url2(lbo)
      if sorgente == false
        segnalaProblema("url2")
      else
        bbo.url2 = sorgente
        bbo.save
      end 

      # annomodifica ( ricavato da c15) -------------------------------------------------------
      sorgente  = tra_annomodifica(lbo)
      if sorgente == false
        segnalaProblema("annomodifica")
      else
        bbo.annomodifica = sorgente
        bbo.save
      end  
 
      # aggiungo due istruzioni eliminate dal main (script ugoRUNTravasa00.rb)
      @statistiche[:id][:nOK] += 1
      mioMaxMin(:id, bbo.id)

     end #def travasaDiretto(bbo, lbo)   

    def segnalaProblema(campo)    # 18/10/2016
      nuovoProblema = sprintf("%5.5s|%12.12s", @@lbooksIDCorrFormattato, campo.ljust(12))
      @@arrayCampiProblematici << nuovoProblema     
    end #def segnalaProblema(campo)

    def self.getCampiProblematici
      return @@arrayCampiProblematici
    end #def getCampiProblematici  

# metodi private, da utilizzare solamente dall'interno della class
    private
    def creaStatistiche()
      #modifica a :vmin in :annomodifica il 14/09/2015
    statistiche = Hash[:id,            Hash[:nOK,  0, :nNO, 0, :vmin, 12000 ,   :vmax,  0],
    statistiche =      :titolo,        Hash[:nOK,  0, :nNO, 0, :vmin, 100   ,   :vmax,  0],
                       :prezzoeurodec, Hash[:nOK,  0, :nNO, 0, :vmin, 100.0 ,   :vmax,  0.0,
                                          :formato, Hash[:punto, 0,
                                                         :virgola, 0,
                                                         :noseparatore, 0,
                                                         :altricasi, 0 ]             ],
                       :isbn,          Hash[:nOK,  0, :nNO, 0, :vmin, 100 ,   :vmax,  0],
                       :copie,         Hash[:nOK,  0, :nNO, 0, :vmin, 100 ,   :vmax,  0],
                       :deposito,      Hash[:nOK,  0, :nNO, 0, :vfalse,  0,   :vtrue, 0],
                       :publisher_id,  Hash[:nOK,  0, :nNO, 0, :vmin, 100 ,   :vmax,  0],
                       :idtipoopera,   Hash[:nOK,  0, :nNO, 0, :vmin, 100 ,   :vmax,  0],
                       :annoedizione,  Hash[:nOK,  0, :nNO, 0, :vmin, 100 ,   :vmax,  0],
                       :idaliquotaiva, Hash[:nOK,  0, :nNO, 0, :nMOD,    0,   :vmin, 100 ,   :vmax,  0],    
                       :url2         , Hash[:nOK,  0, :nNO, 0],
                       :annomodifica , Hash[:nOK,  0, :nNO, 0, :nMOD,    0,   :vmin, 2099,   :vmax,  0]                                             
                       ]             
    end #def creaStatistiche()

    def tra_titolo(lbookObject) 
      sorgente = lbookObject.c02_titolo.strip
      lsorgente = sorgente.size
      if lsorgente.size > 0
        @statistiche[:titolo][:nOK] += 1
        mioMaxMin(:titolo, lsorgente)
        return sorgente
      else #if sorgente
        @statistiche[:titolo][:nNO] += 1 
        return false
      end  #if sorgente
    end #def tra_titolo(lbookObject) 

    def tra_prezzoeurodec(lbookObject) 
      prezzo = lbookObject.c03_prezzoeurodec.strip
      #
      patt0 = /\A(\d{1,5}\.\d{0,2})$/
      patt1 = /\A(\d{1,5},\d{0,2})$/
      patt2 = /\A(\d{1,5})$/
      patt3 = /\A(\d{1,5})\.(\d{0,2})$/
      patt4 = /\A(\d{1,5}),(\d{0,2})\Z/
      re_arra = [patt0, patt1, patt2, patt3, patt4]
      matches = []
      re_arra.each {|miare|
        md = miare.match(prezzo)
        matches << md
      } #re_arra.each     

      case 
      when !matches[0].nil? && !matches[3].nil?   # 2 seq. numeriche con punto separatore
        prezzoFloating = matches[0][1].to_f
        @statistiche[:prezzoeurodec][:formato][:punto] += 1
      when !matches[1].nil? && !matches[4].nil?   # 2 seq. numeriche con virgola separatore
        prezzoFloating = (matches[4][1]+"."+matches[4][2]).to_f
        @statistiche[:prezzoeurodec][:formato][:virgola] += 1
      when !matches[2].nil?                       # 1 sola sequenza numerica senza separatori
        prezzoFloating = (matches[2][0]+".00").to_f
        stat[:prezzoeurodec][:formato][:noseparatore] += 1
      else # case                                 # tutti gli altri casi non considerati
        prezzoFloating = -0.1
        @statistiche[:prezzoeurodec][:formato][:altricasi] += 1
      end
      if prezzoFloating == -0.01
        @statistiche[:prezzoeurodec][:nNO] += 1
      else # if prezzoFloating
        @statistiche[:prezzoeurodec][:nOK] += 1  
        mioMaxMin(:prezzoeurodec, prezzoFloating)    
      end  # if prezzoFloating      

      return prezzoFloating
    end #def tra_prezzoeurodec(lbookObject) 

    def tra_isbn(lbookObject) 
      sorgente = lbookObject.c07_ISBN.strip
      lsorgente = sorgente.size
      #if lsorgente.size > 0
      @statistiche[:isbn][:nOK] += 1
      mioMaxMin(:isbn, lsorgente)
      return sorgente
      #end  #if sorgente
    end #def tra_isbn(lbookObject)     

    def tra_copie(lbookObject) 
      sorgente = lbookObject.c08_copie
      if sorgente.nil?
        @statistiche[:copie][:nNO] += 1 
      return false 
      end  
      @statistiche[:copie][:nOK] += 1
      mioMaxMin(:copie, sorgente)
      return sorgente   
    end #def tra_copie(lbookObject) 

    def tra_publisher_id(lbookObject) 
      sorgente = lbookObject.c10_publisher_id
      if sorgente.nil?
        @statistiche[:publisher_id][:nNO] += 1 
        return false 
      end  
      valid_sorgente = (sorgente > 0 && @publiRange === sorgente)

      if valid_sorgente
        @statistiche[:publisher_id][:nOK] += 1
        mioMaxMin(:publisher_id, sorgente)
        return sorgente
      else  #if valid_sorgente 
        @statistiche[:publisher_id][:nNO] += 1 
        return false 
      end  #if valid_sorgente
    end #def tra_isbn(lbookObject) 

    def tra_deposito(lbookObject) 
      sorgente = lbookObject.c09_deposito
      #riga = "#{sorgente}-#{sorgente.inspect}"
      # => puts riga
   
      @statistiche[:deposito][:nOK] += 1
      
      @statistiche[:deposito][:vtrue]+=1  if sorgente  
      @statistiche[:deposito][:vfalse]+=1 if !sorgente 

      return sorgente
   
    end #def tra_deposito(lbookObject) 

    def tra_idtipoopera(lbookObject) 
      sorgente = lbookObject.c11_IDTIPOOPERA
      if sorgente.nil?
        @statistiche[:idtipoopera][:nNO] += 1 
        return false 
      end
      valid_sorgente = ( sorgente > 0 && @tipoORange === sorgente)
      if valid_sorgente
        @statistiche[:idtipoopera][:nOK] += 1
        mioMaxMin(:idtipoopera, sorgente)
        return sorgente
      else  #if valid_sorgente 
        @statistiche[:idtipoopera][:nNO] += 1 
        return false 
      end  #if valid_sorgente

    end #def tra_isbn(lbookObject)

    def tra_annoedizione(lbookObject) 
      sorgente = lbookObject.c12_ANNOEDIZIONE
      if sorgente.nil?
        @statistiche[:annoedizione][:nNO] += 1 
        return false 
      end   
      @statistiche[:annoedizione][:nOK] += 1
      mioMaxMin(:annoedizione, sorgente)
      return sorgente   
    end #def tra_annoedizione(lbookObject) 


    def tra_idaliquotaiva(lbookObject) 
      # versione 09/08/2014, poi radicalmente cambiata il 25/08/2014 - Samone
      # versione 10/10/2014 aggiunta scrittura su @pippo per casi anomali
      # si mantiene in questo metodo, chiamato da travasaDiretto(bbo.lbo), la funzione di determinare il tipo di idALIVA
      # che caratterizza il record lbo corrente, quella di eventualmente modificarlo (per iva=22%, ma non solo) e quella di
      # aggiornare i contatori per le statistiche.
      # restituisce false se questo idALIVA è COMPLETAMENTE SBALLATO (nil, zero o negativo). In caso contrario restituisce sempre un intero
      # che rappresenta il valore di idALIVA da travasare in books (il travaso è l'unica funzione riservata al chiamante)
      # Attenzione: utilizza il metodo controlla della classe ControlloAliquotaIva, inoltre interagisce con l'utente
      #             tramite il metodo echorun1, opportunamente parametrizzato
      #
      # 1. crea una istanza della cai
      caiobj = ControlloAliquotaIva.new(lbookObject)
      #
      # 2. chiama metodo controlla() per analizzare il tipo di caso in cui ci si trova
      risultato_analisi = caiobj.controlla()
      #
      case risultato_analisi[:codice]
        when 1 # val_nil
           # esce restituendo 0 
           @statistiche[:idaliquotaiva][:nNO] += 1 
           questaRiga =  "*** da tra_idaliquotaiva, errore #{risultato_analisi[:codice]}, "
           questaRiga += "su vecchioid=#{lbookObject.c01_vecchioid} val_nil, posto a false."
           @pippo.scriviRiga(questaRiga)
           return false 

        when 2 # val_inrange           
           # esce restituendo l'id originario
           @statistiche[:idaliquotaiva][:nOK] += 1 
           mioMaxMin(:idaliquotaiva, risultato_analisi[:valoreID]) 
           # unico caso in cui non si traccia nulla su outrunner2.txt  
           return risultato_analisi[:valoreID]        
     
        when 4 # val_outrange_noncorretto          
           # interazione con l'utente, solo nel caso una certa variabile di classe sia stata impostata a false
           # 1. costruisce la informativa (prologo), il prompt e la lambda da usare per filtrare i dati inseriti
           prologo  = "ATTENZIONE!\n"
           prologo += "tra_idaliquotaiva ha rilevato un valore non consentito per c14_idaliquotaiva.\n"
           prologo += "Record: #{caiobj.lbookObject.id}, valore non consentito: #{risultato_analisi[:valoreID]}.\n"
           prologo += "Puoi sostituire, nel travaso, questo valore con uno da te scelto.\n"
           prologo += "Inserisci un intero positivo da 1(iva=0) a 4(iva=22) e dai 'Invio'.\n"
           prologo += "Digita la parola 'abort' se vuoi chiudere ogni attivita' di esecuzione."
           #
           prompt = "sostituisci #{risultato_analisi[:valoreID]} con > "
           #
           miaLambda = lambda{|a| if a =~ /^\d+$/ && (1..4) === a.to_i
                                    nuovoid = a.to_i
                                    puts "Vecchio idALIVA(#{risultato_analisi[:valoreID]}) sostituita da: #{nuovoid}."
                                    puts "Vuoi che nei prossimi eventuali casi analoghi, questo stesso valore venga usato per la sostutuzione?"
                                    return nuovoid
                                  else
                                    # qui nel caso la stringa a non (sia composta di sole cifre and sia nel range 1-4)
                                    if a.chomp == "abort"
                                        return -99
                                    else
                                        return -1
                                    end  
                                  end #a =~ /^\d+$/  
                              }  
           # esegue la interazione con la console                                 
           nuovoid = @@consoleTravasa.echorun1(prologo, prompt, miaLambda)
            # attenzione: questo comporta che la tabella idAliquotaIva 
            # possa dovere avere un nuovo (quarto) elemento per id=4 (iva=22) (nei casi in cui nuovoid=4)           
           puts "-----return da lambda = #{nuovoid}"
           # tratta il caso di richiesta di abort
           if nuovoid == -99
             abort("Fine run programmata") if @pippo.cnslLeggi("\nrichiesto abort su idALIVA; Vuoi CHIUDERE TUTTO? (S/N)").upcase == "S"
           end
           
           if nuovoid == -1
             # esce restituendo false
             @statistiche[:idaliquotaiva][:nNO] += 1 
             questaRiga =  "*** da tra_idaliquotaiva, errore #{risultato_analisi[:codice]}, "
             questaRiga += "su vecchioid=#{lbookObject.c01_vecchioid}."
             @pippo.scriviRiga(questaRiga) 
             questaRiga =  "    val. originario in lbooks: #{lbookObject.c14_idaliquotaiva}, tentata modifica, con errore (NON travasato)."
             @pippo.scriviRiga(questaRiga)              
             return false 

           else #if nuovoid == -1 
             # nel caso in cui l'utente abbia già risposto positivamente, la sostituzione viene fatta in modo 'silente'
             # esce restituendo l'id originario modificato
             @statistiche[:idaliquotaiva][:nOK] += 1 
             @statistiche[:idaliquotaiva][:nMOD] += 1 
             mioMaxMin(:idaliquotaiva, nuovoid)  
             questaRiga =  "*** da tra_idaliquotaiva, errore #{risultato_analisi[:codice]}, "
             questaRiga += "su vecchioid=#{lbookObject.c01_vecchioid}."
             @pippo.scriviRiga(questaRiga) 
             questaRiga =  "    val. originario in lbooks: #{lbookObject.c14_idaliquotaiva}, modificato in: #{nuovoid} (travasato)."
             @pippo.scriviRiga(questaRiga) 
            return nuovoid
           end #if nuovoid == -1

        else   # sostanzialmente il caso 3 = val_outrange_corretto
          puts "..tra_idaliquotaiva: caso non previsto: #{risultato_analisi[:codice]}, valore: #{risultato_analisi[:codice]}" 
          @statistiche[:idaliquotaiva][:nNO] += 1 
          questaRiga =  "*** da tra_idaliquotaiva, errore #{risultato_analisi[:codice]}, "
          questaRiga += "su vecchioid=#{lbookObject.c01_vecchioid}."
          @pippo.scriviRiga(questaRiga) 
          questaRiga =  "    val. originario in lbooks: #{lbookObject.c14_idaliquotaiva}, valore non consentito (NON travasato)."
          @pippo.scriviRiga(questaRiga) 
          return false      
     
      end #case risultatoanalisi[:codice]      

    end #def tra_idaliquotaiva(lbookObject)


    def tra_idaliquotaiva_OLD(lbookObject) 
      sorgente = lbookObject.c14_idaliquotaiva
      debugRiga = " tra_idaliva:- - -#{lbookObject.id} #{sorgente} - - -"
      @pippo.scriviRiga(debugRiga)
      #
      case 
      when sorgente == 0
        @statistiche[:idaliquotaiva][:nOK] += 1
        return sorgente
      when sorgente.nil?
        abort("Fine run programmata") if !@pippo.cnslLeggi("idaliquotaIVA=nil; Vuoi Continuare? (S/N)").upcase == "S"

        sorgente = 0
        @statistiche[:idaliquotaiva][:nOK] += 1
        @statistiche[:idaliquotaiva][:nMOD] += 1
        return sorgente
      when sorgente > 4
        abort("Fine run programmata") if @pippo.cnslLeggi("idaliquotaIVA>4, (valore= #{sorgente}); Vuoi Continuare? (S/N)").upcase == "N"
      
    
        sorgente = 0
        @statistiche[:idaliquotaiva][:nOK] += 1
        @statistiche[:idaliquotaiva][:nMOD] += 1
        return sorgente
      else # case  qui nel caso standard
        @statistiche[:idaliquotaiva][:nOK] += 1
        mioMaxMin(:idaliquotaiva, sorgente)
        return sorgente      
      end # case
      #   
    end #def tra_idaliquotaiva_OLD(lbookObject) 

    def tra_url2(lbookObject)
      sorgente = lbookObject.c15_url2.strip
      if sorgente.nil?
        @statistiche[:url2][:nNO] += 1 
        return false 
      end   
      @statistiche[:url2][:nOK] += 1
      return sorgente
    end #def tra_url2(lbookObject)  

    def tra_annomodifica(lbookObject)
      sorgente = estraiAnnoDaUrl2(lbookObject.c15_url2)
      if sorgente[:errore]
        @statistiche[:annomodifica][:nNO] += 1
        return false
      else
        @statistiche[:annomodifica][:nOK] += 1
        mioMaxMin(:annomodifica, sorgente[:valore])
        return sorgente[:valore]
      end
    end #def tra_annomodifica(lbookObject) 

    def estraiAnnoDaUrl2(url2_string)
      # restituisce un hash a due chiavi ( :errore e :valore)  
      # in caso di :errore = true in :valore si riporta il testo dell'errore
      # in caso di :errore = false in :valore si riporta il valore di annomodifica
      # in formato integer. Nei casi in cui sono presenti solo due cifre, si
      # restituisce il valore numerico ottenuto sommando 2000 al numero ottenuto
      # modificato per inventario 2014 il 14/09/2015
      annoInventario_4 = 2015   # da modificare anno per anno modif 2016
      annoInventario_2 = 15     # da modificare anno per anno modif 2016

      erHash = {errore: true,  valore: "errore"}   
      okHash = {errore: false, valore: 0}         
      #patt0 = /\A<\d\d\\\d\d\\(\d{2}|\d{4})><(.*)>\Z/
      patt0 = /\A<\d\d\/\d\d\/(\d{2}|\d{4})><(.*)>\Z/

      md0 = patt0.match(url2_string)
      if !md0.nil?
        case           
        when md0[1].size == 2 || md0[1].size == 4
          questoValore_num = md0[1].to_i
          mioRange = (0..annoInventario_2) if md0[1].size == 2
          mioRange = (1900..annoInventario_4) if md0[1].size == 4
          if mioRange === questoValore_num
            questoValore_num = questoValore_num + 2000 if md0[1].size == 2
            return okHash.merge({valore: questoValore_num})
          else # if mioRange
            return erHash.merge({valore: "anno(#{questoValore_num}) in url2(#{url2_string}) fuori range"})  
          end  # if mioRange
        else # case  
          return erHash.merge({valore: "anno(#{md0[1]}) in url2(#{url2_string}) non valido"})   
        end  # case

      else #if!md0.nil?
        return erHash.merge({valore: "nessun match in #{url2_string} ."})
      end  #if!md0
    end #def estraiAnnoDaUrl2(url2_string)



    def mioMaxMin(chiaveSymbol,valore)
      if !valore.nil?
        if valore > @statistiche[chiaveSymbol][:vmax]
          @statistiche[chiaveSymbol][:vmax] = valore
        end
        if valore < @statistiche[chiaveSymbol][:vmin]
          @statistiche[chiaveSymbol][:vmin] = valore
        end
      end #!valore.nil?
    end #def mioMaxMin(chiaveSymbol,valore)



  end #class Travasa


module MetodiPerProvetta
  require 'io/console'
  require 'readline'
  #
  def consoleInput
    print "Inserisci una stringa (che vedrai anche mentre la batti): "
    name = gets
    puts "Hai inserito in chiaro la stringa seguente: #{name.chop}."
  end #consoleInput

  def consoleInputNascosto
      password = STDIN.noecho do
      print "Inserisci la tua password (mentre la batti non la vedrai):"
      gets
    end
    puts "\nLa pw inserita (con noecho) valeva: #{password.chop}."
  end #consoleInputNascosto

  def echorun0
    # vedere Ceresa p.85
    puts "inserisci una stringa e premi Invio."
    puts 'digita quit per uscire.'
    loop do
      print "echorun0> "
      a = gets
      break if a.chomp == "quit"
      puts a
    end #loop do
  end #  def echorun

  def echorun1(prologo="Inserisci una stringa e premi Invio.", prompt="echorun1> ", miaLambda = lambda{|x| puts x
                                                                                                           return 0} )
    stringa = 'nulla'
    # vedere Ceresa p.87 11 agosto 2014 OK, DT a p.115-116 per arg con valori di default
    # fa precedere il primo messaggio da alcune righe vuote
    puts "\n\n"
    puts prologo
    puts 'Digita quit per uscire da questo ambiente interattivo;'
    puts 'oppure history per la lista delle righe inserite fino ad ora.'
    loop do
      a = Readline.readline prompt
      stringa = a
      Readline::HISTORY.push(a)
      case a
       when "quit"
          break
        when "history"
          p Readline::HISTORY.to_a
        when "abort"
          break  
        else
          puts a          
      end # case a  
      # usciamo dal loop (end #loop) in casi particolari
      break if a.chomp == "quit" 
      break if a.chomp == "abort" 
      # nel caso 'normale' chiamiamo la lambda definita negli argomenti        
      lambda_risult = miaLambda.call(a)
      if lambda_risult > 0
        return lambda_risult
      else
        puts "'#{a}' non consentito" if a.chomp.upcase != "HISTORY" 
      end #if lambda_risult > 0

    end #loop  
    puts "echorun1. stringa in uscita dal loop: #{stringa}"
    return -99 if stringa.chomp == 'abort'
  end #def echorun1
end #module MetodiPerProvetta

class Provetta
  include MetodiPerProvetta
  attr_reader :isbn
  attr_accessor :price
  def initialize(isbn, price)
    @isbn = isbn
    @price = Float(price)
  end #initialize

end #Provetta


