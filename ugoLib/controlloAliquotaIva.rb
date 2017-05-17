#module MetodiPerProvetta
# modificato Hash con chiave :lambdas il 08/10/14 (piccola e inutile modifica sintattica)
# aggiunto metodo di classe lista_formattata_errati dal 14/10/2014 al 15/10
require "./ugoLib/tuttoTravasa0.rb"
   class ControlloAliquotaIva
    #include MetodiPerProvetta
       COSTANTI = Hash[ :id_ammessi,   Range.new(1,3), 
                        :casi,         Hash[:val_nil,                   1,
                                            :val_inrange,               2,
                                            :val_outrange_corretto,     3,
                                            :val_outrange_noncorretto,  4],
                        :lambdas,      Hash[:val_nil,     lambda{|idALIVA| 
                                                                  ritorna = COSTANTI[:casi][:val_nil]
                                                                  nilOZero = idALIVA.nil? || idALIVA == 0
                                                                  ritorna = -ritorna if nilOZero
                                                                  ritorna},
                                            :val_inrange, lambda{|idALIVA|
                                                                  ritorna = COSTANTI[:casi][:val_inrange]
                                                                  in_range = COSTANTI[:id_ammessi] === idALIVA
                                                                  ritorna = -ritorna if in_range
                                                                  ritorna},
                                            :val_outrange_corretto , lambda{|idALIVA|
                                                                  ritorna = COSTANTI[:casi][:val_outrange_corretto]
                                                                  in_range = COSTANTI[:id_ammessi] === idALIVA
                                                                  corretto = false
                                                                  ritorna = -ritorna if (!in_range && corretto)
                                                                  ritorna},
                                            :val_outrange_noncorretto , lambda{|idALIVA|
                                                                  ritorna = COSTANTI[:casi][:val_outrange_noncorretto]
                                                                  noncorretto = true
                                                                  in_range = COSTANTI[:id_ammessi] === idALIVA
                                                                  ritorna = -ritorna if (!in_range && noncorretto)
                                                                  ritorna}                                                                     
                                           ],
                        :debug0,      false]                                                           

       attr_reader :range_ammessi, :lbookObject

       @@quanti_records = 0
       @@elenco_errati  = []
       @@mia_console = 0

       def initialize( lbookObject )
           @@quanti_records += 1
    	     @range_ammessi = COSTANTI[:id_ammessi]
    	     #puts "@range_ammessi da controllo = #{@range_ammessi.inspect}"

           # memorizza in ogni caso (per tutti i record trattati) l'oggetto lbookObject in una variabile di istanza
           # queste informazioni saranno accumulate in un array di classe (@@elenco_errati)
           # solo per i record che contengono un idALIVA non ammesso
           @lbookObject = lbookObject           
           #
           if @@mia_console == 0
              @@mia_console = Provetta.new("123", 123.4)
              @@mia_console.echorun1  if COSTANTI[:debug0] # prova di chiamata di echorun1 senza argomenti (usa i default)
           end #if @@mia_console   
       end #def initialize

       def controlla()
        # 25/08/2014 - Samone - ora questoid viene estratto dalla variabile di istanza che contiene tutto l'oggetto
        # verifica a che tipologia appartiene il record la cui immagine (lbooks) 
        # é contenuta nell'ultimo elemento dell'array @@elenco_errati
        #questoid = @@elenco_errati[@@quanti_records -1].c14_idaliquotaiva
        #
        questoid = @lbookObject.c14_idaliquotaiva
        #chiamiamo il metodo private determinaCaso(questoid)
        casotrovato = determinaCaso(questoid)   #restituisce un intero da 1 a 4 (di norma non il 3)
        puts "---------------controlla, idALIVA= #{questoid}, CASOTROVATO= #{casotrovato} ----" if COSTANTI[:debug0]
        # memorizza in un array di classe @@elenco_errati, gli oggetti lbooks che contengono idALIVA
        # non corretto:
        if casotrovato != 2 #val_inrange           
           @@elenco_errati << @lbookObject   # per i casi corrispondenti a errori vari viene immagazzinato l'intero lbookObject
        end #if casotrovato <> 2 #val_inrange

        # restituisce in ogni caso un hash con due elementi chiave-valore
        return { :codice   => casotrovato,
                 :valoreID => questoid } 

       end #def controlla()
        
       def ControlloAliquotaIva.get_quanti_records()
           @@quanti_records
       end #ControlloAliquotaIva.get_quanti_records

       def ControlloAliquotaIva.get_elenco_errati()
            @@elenco_errati
       end #def ControlloAliquotaIva.get_elenco_errati()


     private

       def determinaCaso(idALIVA)
        # determina a quale dei 4 previsti casi mutuamente esclusivi (da 1 a 4) appartiene idALIVA
        # l'id dell'Aliquota IVA assegnata al libro corrente in lbooks ( di norma da 1 a 3; già trovati 22 e 121, errori)
          catch(:trovato) do 
            COSTANTI[:casi].each_pair { |chiave, valore|
               codice = valore
               risultato = COSTANTI[:lambdas][chiave].call(idALIVA)
               throw(:trovato, codice) unless risultato > 0
            } # COSTANTI.each_pair
          end #cath(:trovato)
       end #def determinaCaso(idALIVA)



    end #class ControlloAliquotaIva
#end #module
