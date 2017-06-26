#!/usr/local/bin/ruby

require "./ugoLib/ugorunnerXUtil01.rb"
mioScript = "UgoRUNBidoniInPublishers01.rb"
pippo = Konta.new("#{mioScript} - vers.17/06/17. Riempie la tabella publishers con bidoni.","0")
#

def inizializza(pippo)
  maxLpub = Lpublisher.maximum(:ID_EDITORE)
  pippo.scriviRiga("Max ID_EDITORE in tab. lpublishers: #{maxLpub}.") 
  ltab = Publisher.all   # 2014
  pippo.scriviRiga("Totale Elementi Iniziali in tab. publishers: #{ltab.size}.")  
  # 
  salvataggio = true   #false
  inizio = 1
  fine = maxLpub
  riga = "Si creano bidoni a partire da #{inizio} fino a #{fine}\n"
  print riga
  riga ="Salvataggio: #{salvataggio.inspect}"
  print riga
  return inizio, fine, salvataggio
end #  def inizializza(pippo)
# ============================================================================
stampaSorgente = false 
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}")
  # utilizziamo il metodo che abbiamo definito in Publisher model
  # e creariamo in esso alcuni bidoni
  #--------------------------------------------------------------------
  inizio, fine, salvataggio = inizializza(pippo) 
  conta = 0
  (inizio..fine).each do |numero| 
     ritorno = Publisher.creaSalvaNuovoRecord(numero, salvataggio)
     pippo.scriviRiga(ritorno)
     conta += 1
     print "."
  end 
  if !salvataggio
     riga ="Creati (ma non salvati) #{conta} bidoni in publishers."
  else
     riga ="Creati e salvati #{conta} bidoni in publishers."
  end   
  pippo.scriviRiga(riga)
  #--------------------------------------------------------------------

  pippo.scriviRiga("Risultati end#")

end # stampaSorgente
pippo.fineJob  