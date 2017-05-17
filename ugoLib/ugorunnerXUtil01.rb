#!/usr/bin/env ruby
require 'io/console'
require 'abbrev'
class Konta
  N_COLONNE = 3
  PAD_STR = '0'
  @nRiga = 0
  SEPARATORE = "| "
  LIMITE = 65
  # crea un oggetto per la conta e la stampa delle frequenze di elementi sparsi
  # utilizza hash per minimizzare memoria
  # serve anche per la stampa di singole righe, cui prepone un prefisso del tipo 00n: e mette
  # un separatore (@separatore) e il fine riga
  # 20 gennaio 2013
  def initialize (fraseIniziale, separatore)
    @@mioKonta = Hash.new
    @f = File.new("outrunner2.txt", "w")
    # timedate 28/06/2013
    nuovaFrase = fraseIniziale + " eseguito il " +Time.new().to_s.gsub(" +0200", "")
    @nRiga = 1
    @f.write(formatta0()+"..inizio.. #{nuovaFrase}\n")
    @separatore = separatore
  end
  def somma(chiave)
=begin rdoc
A ogni chiamata, questo metodo della classe Konta controlla se nell'hash
di nome @@mioKonta esiste già la key di nome chiave. In caso positivo
somma 1 al suo contenuto; in caso negativo crea l'elemento con key=chiave
e con valore uguale a 1
=end
    if @@mioKonta.has_key?(chiave)
      valprec=@@mioKonta[chiave]
      valnew = valprec+1
      @@mioKonta[chiave]=valnew
    else
      @@mioKonta[chiave] = 1
    end
  end
  def scriviRiga(testo)
    # scrive una riga logica sul file @f
    # incrementa il contatore di righe @nRiga 
    @nRiga += 1
    # se la lunghezza di testo supera LIMITE costruisce un array con i diversi spezzoni
    # in cui viene suddivisa la stringa testo iniziale
    if testo.size > LIMITE
      blocchi = tronca0(testo, LIMITE)
      kontablocchi = 0
      blocchi.each {|b|
        if kontablocchi == 0
          @f.write(formatta0+b+"\n")
        else
          @f.write(formatta1+b+"\n")
        end
        kontablocchi += 1   
      }
    else
      @f.write(formatta0+testo+"\n")
    end

  end
  
  def stampa
    @nRiga += 1
    @f.write(formatta0()+"Frequenze (numero di microposts per user) nel feed\n")
    @@mioKonta.map do |k,v|
      @nRiga += 1
      @f.write( formatta0()+"User: #{k.to_s}, n.roMicroposts: #{v.to_s}\n")
    end
  end

  def fineJob
    puts "fine job: #{@nRiga.to_s} righe."
  end  

  def cnslLeggi(messaggio)
=begin
legge da console e restituisce la stringa letta, senza l'ultimo carattere di controllo
usa io/console
=end 
    caso = 0
    caso = 1 if messaggio.index("?")==messaggio.size
    case caso
    when 0
      risult = STDIN.noecho do
      print messaggio 
      gets
      end #STDIN.noecho do
      risult = risult.chomp
      print risult+"\n" #mostra la parola dopo che si è dato l'invio
      return risult
    end #case
  end # def cnslLeggi

  def cnslAbbrev(mioArr)
    puts mioArr.inspect
    comH = mioArr.abbrev
    puts comH.inspect
    while line = gets
      line = line.chomp
      voce = comH[line]
      esiste = false
      mioArr.each do |ele|
        if voce == ele
          esiste = true
          break
        end
      end
      if esiste
        return voce   
      else #esiste
          STDERR.puts "Unknown command: #{line}"
          return "sconosciuto"
      end # case
    end #while
  end #def csnAbbrev
  
  private
  def formatta0()
=begin rdoc
restituisce l'intero @nRiga sotto forma di stringa su NCOLONNE con PAD_STR sulla sinistra
=end
    stringa = @nRiga.to_s.rjust(N_COLONNE, PAD_STR)+ SEPARATORE    
  end

  def formatta1()
=begin rdoc
restituisce una stringa come quella fornita da formatta0
con la differenza che al posto delle cifre e dei caratteri
PAD_STR contiene dei blanks. La sua lunghezza est NCOLONNE 
seguito dalla stringa SEPARATORE
=end
    stringa = " ".rjust(N_COLONNE, " ")+ SEPARATORE    
  end

  def tronca0(stringa, colonne)
=begin
suddivide stringa in sottostringhe (blocchi) non più lunghe di colonne caratteri
modificato per restituire un array (blocchisuddivisi)
22 aprile 2013
=end    
    ss=[] # array temporaneo nel quale viene formato un blocco 
    k=0   # conta i caratteri nel blocco
    a=stringa
    b=a.split('')    #trasforma tutta la stringa data in array b
    blocchisuddivisi = []
    b.each {|e|
       if ss.size == colonne
         xx = ss.join()   # xx est stringa con blocco
         blocchisuddivisi << xx
         ss=[]
         k=0
         ss<<e
         k=1
       else
        ss<<e
        k +=1 
       end
    }
    # se l'ultimo blocco ss ha lunghezza minore di colonne
    # deve ancora essere inserito nell'array finale blocchisuddivisi
    if ss.size < colonne
       xx=ss.join() 
       blocchisuddivisi << xx
    end
    return blocchisuddivisi
  end
end
