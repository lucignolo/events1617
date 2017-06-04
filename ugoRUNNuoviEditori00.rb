#!/usr/local/bin/ruby
require "./ugoLib/ugorunnerXUtil01.rb"
mioScript = "ugoRUNNuoviEditori00.rb"
pippo = Konta.new("#{mioScript} - 2016: da lpublishers a publishers","0")

def lunga(nome, id, id_editore, pippo)
    #nome = self.Nome
    stringa = nome.strip
    lstringa = stringa.size
    #p  "stringa: #{stringa}, l: #{lstringa}"
    if lstringa == 0
       #pippo.scriviRiga("zero trovato in: #{id_editore}")
    end #    
    #
    lstringa
end #def lunga

def primoMaiuscolo(stringa)
  # rende maiuscolo il primo carattere di stringa
  salva = stringa
  lsalva = stringa.size
  primoMaiuscolo = salva[0].upcase
  nuovo = primoMaiuscolo + salva[1, lsalva-1]
end #def primoMaiuscolo(stringa)

def do_at_exit(str1)
   at_exit { print str1 }
end
#at_exit { puts "cruel world" }
#do_at_exit("goodbye ")
#exit
#produces:
#goodbye cruel world
# =======================================================================
stampaSorgente = false #true
if stampaSorgente
  File.new(mioScript,"r").each_line {|line| pippo.scriviRiga(line.chop)}
else
  pippo.scriviRiga("Risultati start#")
  pippo.scriviRiga("Encoding in uso: #{__ENCODING__.name}; prova: èòìàéù")
  pippo.scriviRiga("Esegue solo prima parte.")

  faiPrimaParte = true
  if faiPrimaParte

  # legge tutti i record che stanno in Lpublishers   #2014 fatto il 03/09/2015
  ltab = Lpublisher.all   # 2014
  pippo.scriviRiga("Totale Elementi in tabella lpublishers: #{ltab.size}.")

  mioh = {1 => ''}
  h2 = Hash.new
  iii = 0
  ltab.each{|lpo|
    iii += 1
    #break if iii == 882 
    if lpo.lunga1(pippo) > 0   #lunga1 è un metodo di istanza della classe Lpublishers (model)
       h2 = {lpo.ID_EDITORE => lpo.Nome}
       mioh.merge!(h2)
    else
       rigaNULLI = "lung Nome=0 in iii: #{iii}, lpo.ID_EDITORE: #{lpo.ID_EDITORE}" 
       p rigaNULLI
       pippo.scriviRiga(rigaNULLI)  
    end #if lunga1() > 0

    #break if iii==10
  }
  # 2016: estrae la chiave più alta
  hashSize = mioh.size
  massimaChiave = mioh.keys[hashSize-1]  
  pippo.scriviRiga("Massimo valore per ID_EDITORE: #{massimaChiave}")

  # 2017: verifica se in mioh esistono elementi con valore nullo
  # 2017: conteggia un nuovo valore per massimaChiave, in mioh, NON in lpublishers
  contaZero = 0
  contaNoZero = 0
  massimaChiave = 0
  minimaChiave = 2000
  mioh.each_pair{|k, v|
    if v.strip.size == 0
      p "zero in mioh: #{k}"
      contaZero += 1
    else
      contaNoZero += 1
      #
      if k > massimaChiave
        massimaChiave = k
      end
      #
      if k < minimaChiave
        minimaChiave = k
      end

    end
  }
  rigaZero = "Numero di valori NULLI in mioh: #{contaZero.to_s}."
  pippo.scriviRiga(rigaZero)
  rigaNoZero = "Numero di valori NON NULLI in mioh: #{contaNoZero}."
  pippo.scriviRiga(rigaNoZero)
  rigaMaxMin = "in mioh, chiave Minima: #{minimaChiave}; chiave Max: #{massimaChiave}."
  pippo.scriviRiga(rigaMaxMin)

at_exit { puts "finita costruzione mioh;" }
do_at_exit("conclusa prima parte;")

pippo.fineJob
exit   #=============================================================

#  DA FARE la parte che segue, al 03/06/2017
# ora possiamo scorrere ptab e vedere di estrarre da mioh i titoli opportuni

  quantiPublisher = massimaChiave # <-2016; 2015->977 #952 #10 #921
  questoRange = Range.new(1, quantiPublisher)
  ntrovati = 0
  nontrovati = 0
  nlzero = 0
do_at_exit("inizializzata seconda parte;")  
#exit  
  questoRange.each{|num|
    pobj = Publisher.find(num)
    chiave = pobj.id   #Publisher.find(num).id
    if mioh.has_key?(chiave)
      nomeEditore = mioh[chiave]
      # aggiungere qui le istruzioni per il travaso in pobj.nome

      pobj.nome = nomeEditore

      if pobj.nome.strip.size == 0   #nomeEditore.strip!.size == 0
        nlzero += 1
        nomeEditore = "nonono" + " -#{chiave}"
        pobj.nome = nomeEditore
      end #  if nomeEditore  
      pobj.save

      #
      ntrovati += 1
    else  #if
      nontrovati += 1
      # 2016: aggiungiamo il controllo che il record corrente in publishers,
      # ossia la variabile pobj, abbia già impostato il campo nome al valore per un bidone,
      # ossia cominci con "nonono"
      if pobj.nome.start_with?("nonono")
           # tutto ok: il rec corrente in publishers ha il nome deibidoni
      else
           do_at_exit("incoerenza in un record bidone;")
           exit
      end # if      
    end  #if
  }
  pippo.scriviRiga("trovati:#{ntrovati}; NON trovati:#{nontrovati}; nome lung. 0: #{nlzero}.")  
  do_at_exit("conclusa seconda parte;")  

#else # faiPrimaParte

  # parte seconda: analizzare tutti i record di publishers ed elencare quelli (a parte i bidoni) che
  # presentano come primo carattere del campo nome un carattere non alfabetico maiuscolo
  # lavoriamo come lavora lo script per l'inventario, fissando un range del tipo ('A'..'Z')
  rangeIniziale = Range.new("A","Z")
  rangeMinuscole = Range.new("a","z")
  rangeCifre = Range.new("1","9")
  do_at_exit("inizializzata terza parte;") 
  #exit
  #
  tuttiEditori = Publisher.all
  tuttiEditori.each{|pobj|
  if pobj.nome.index("nonono").nil?  # limita il lavoro ai record NON BIDONE
    if !rangeIniziale.include?(pobj.nome[0])
      primo = pobj.nome[0]
      # qui dobbiamo prevedere 3 casi distinti
      # 1. la iniziale del titolo è una lettera minuscola
      # 2. La iniziale del titolo è una cifra
      # 3. la iniziale del titolo è un carattere diverso dai 2 precedenti
      mioCaso = 3
      mioCaso = 1 if rangeMinuscole.include?(primo)
      mioCaso = 2 if rangeCifre.include?(primo)

      riga = "---> #{pobj.id}, #{pobj.nome}, #{mioCaso}"
      pippo.scriviRiga(riga)

      case mioCaso
      when 1  #primo carattere alfa minuscolo
        nuovo = primoMaiuscolo(pobj.nome.rstrip)  
        #riga = "nuovo: #{nuovo}"
        #puts riga
      when 2  # primo carattere numerico
        salva = pobj.nome.rstrip
        lunga = salva.size
        #esamina la stringa fino a trovare il primo carattere alfabetico
        #rendilo maiuscolo e aggiungi fino alla fine
        doveAlfa = salva.index(/[a-z]/)
        nuovo = salva[doveAlfa,lunga-doveAlfa] +" ["+salva+"]"
        nuovo = primoMaiuscolo(nuovo)
        #riga = "nuovo: #{nuovo}"
        #puts riga
        
      when 3 # primo carattere non alfabetico
        salva = pobj.nome.rstrip
        lunga = salva.size
        nuovo = salva[1,lunga-1]
        primonuovo = nuovo[0]
        nuovo = primonuovo.upcase+nuovo+" ["+salva+"]"
      else
        
      end  # case mioCaso
      riga = "nuovo: #{nuovo}"
      pippo.scriviRiga(riga)
      #
      pobj.nome = nuovo
      pobj.save
    end #if !range
  end
  }

  do_at_exit("terminata terza parte;") 
  #exit
  pippo.scriviRiga("Risultati end#")
end # faiPrimaParte  
end # stampaSorgente
pippo.fineJob
exit
