class Book < ApplicationRecord
belongs_to :publisher
	
	scope :notlikeat, ->(parametro='%titolobidone%') { where("titolo NOT LIKE ?",parametro)}
	scope :likeat, ->(parametro='%titolobidone%') { where("titolo LIKE ?", parametro)}

	# 2016 per inventario 2015: il seguente scope (ambito) bidoni serve per contare i bidoni
	scope :bidoni, -> { where('titolo LIKE "%titolobidone"') }
	scope :nobidoni, -> { where('titolo NOT LIKE "%titolobidone"')}
    # ancora 2016 per inv. 2015: dallo scope che segue (omonimo del cugino in Lbook)
    # possiamo ottenere un hash con le frequenze dei diversi valori del campo idaliquotaiva
	scope :gruppiIVA, -> { group("idaliquotaiva").count }

	scope :tuttibase, -> { select("id, vecchioid, titolo, publisher_id") }
	scope :minid, -> { minimum(:id)}
	scope :maxid, -> { maximum(:id)}
	scope :minvid, -> { minimum(:vecchioid)}
	scope :maxvid, -> { maximum(:vecchioid)}

	scope :badTipoOpera, -> { group("idtipoopera").count }
	def self.badOpera(tipo)
		where("idtipoopera < ?", tipo)
	end #self-badOpera	

  # 2017 per AI16 Samone 20/08
  scope :gruppiANNOMODIFICA, -> { group("annomodifica").count }

    def estraiAnnoDaUrl2(url2_string)
      # restituisce un hash a due chiavi ( :errore e :valore)  
      # in caso di :errore = true in :valore si riporta il testo dell'errore
      # in caso di :errore = false in :valore si riporta il valore di annomodifica
      # in formato integer. Nei casi in cui sono presenti solo due cifre, si
      # restituisce il valore numerico ottenuto sommando 2000 al numero ottenuto
      # modificato per inventario 2014 il 14/09/2015
      annoInventario_4 = 2016   # da modificare anno per anno modif 2016
      annoInventario_2 = 16     # da modificare anno per anno modif 2016

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

    def aggiungi(azione, hashdati = {}, valore = nil)
      if azione == :crea
        {tutti: 0, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0}   #"azione era crea" 
      else
        if hashdati.has_key?(azione)
          hashdati[azione] += valore
          return hashdati
        else
          return nil
        end
      end
    end #aggiungi

    ## prova ad accedere alla classe PdfStuff che sta in lib
    def accediLibreria
        oggetto=PdfStuff::Receipt.new()
        oggetto.hello
    end

    def self.accediLibreriadiClasse()
      a ="sono un metodo di classe! e restituisco il risultato di un altro metodo di clssse"
      a += "#{PdfStuff::Receipt.metododiclasse}"
    end #self.accediLibreriadiClasse

    require "provaNOCLASSE/provaUgo0"
    def self.provaprovaUgo0
      provaUgo0
    end #def self.provaprovaUgo0

    require "provaNOCLASSE/daIDaIVA"
    def self.chiamadaIDaIVA(para)
      daIDaIVA(para)
    end #def self.chiamadaIDaIVA(para)


  #scope :ammessiInventario2016, -> { where('titolo NOT LIKE "%titolobidone" AND copie > 0')}
  #scope :ammessiInventario2016, -> { where(" titolo NOT LIKE ? AND copie > ? AND deposito = ? ", 
  #                                           "%titolobidone", 0, false)}
  #scope :ammessiInventario2016, -> { where(" titolo NOT LIKE ? AND copie > ? AND deposito = ? AND (prezzoeurodec >= ? AND prezzoeurodec <= ?) ", 
  #
  scope :ammessiInventario2016, -> { 
  	where(" titolo NOT LIKE ? AND copie > ? AND deposito = ? AND (prezzoeurodec >= ? AND prezzoeurodec <= ?) AND (annomodifica >= ?) ", 
                                             "%titolobidone", 0, false, 0, 500, 2000)}  

  def vedi
  	x =     " TIT:  #{self.titolo} --"
  	x = x + " COP:  #{self.copie}  --"
  	x = x + " DEP:  #{self.deposito}  --"
  	x = x + " PRE: #{self.prezzoeurodec}  -- "
  	x = x + " MOD: #{self.annomodifica}  --"
  	x
  end #vedi 

  def asse( tito, copi, depo, prez, modi )
  	self.titolo = tito
  	self.copie = copi
  	self.deposito = depo
  	self.prezzoeurodec = prez
  	self.annomodifica = modi
  end #asse


end
