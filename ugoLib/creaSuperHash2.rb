def creaSuperHash2()
=begin
Ispirato (e in pratica copiato) da creaSuperHash, metodo presente nello script
ugoRUNImportaBooks0.rb.
costruisce l'hash questoHash, che contiene tutti i dati sugli attributi
del Book model, ripresi da creaSuperHash in ugoRUNImportaBooks0.rb con modifiche,
necessari alla formazione dell'Inventario.
La struttura dell'Hash come minimo comprende quella definita nel metodo creaSuperHash,
tutti gli elementi vengono mantenuti come chiavi, ma il loro valore,
in alcuni casi è posto a nil. Tipici casi, l'elemento con chiave :lambda1,
e quelli con chiavi :patt1, :patt2; :camposeq
Argomenti: nessuno, grazie alla soppressione delle lambda in cui erano necessari
24/07/2013 Samone 
modificato il 21/10/13 per trattamento del nuovo campo triplo "edimodisb"         
=end  
questoHash = Hash.new()
# ottenuto dall'output di ugoRUNBooks01.rb poi pulito in excel e da lÃ¬ importato
#------- definisce una componente di questoHash
valoriHash = Hash.new
valoriHash[:type1]='INTEGER'
valoriHash[:type2]=' PRIMARY KEY AUTOINCREMENT NOT NULL'
valoriHash[:valore]= 2341
valoriHash[:patt1]=%r{(.*)}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=true
valoriHash[:formato]="%6i"
questoHash[:id] = valoriHash
#------- definisce una componente di questoHash: titolo
valoriHash = Hash.new
valoriHash[:type1]='text'
valoriHash[:type2]=''
valoriHash[:valore]= "prova titolo xxx"
valoriHash[:patt1]=%r{^(.{1,70})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil 
valoriHash[:camposeq]=nil
valoriHash[:elabora]=true
valoriHash[:formato]="%-40.40s"   #variato il 13/09/2013 ore 11:13: con la precision tronca 
questoHash[:titolo] = valoriHash

#------- definisce una nuova componente di questoHash: publisher_id
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= 13
valoriHash[:patt1]=%r{^(\d{1,3})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=lambda { |x| z=mierighe[x]
      validPatt = questoHash[:publisher_id][:patt1] 
      returnHash=ideditore(z, pattern, validPatt, pippo)  }
valoriHash[:camposeq]='IDEDITORE'
valoriHash[:elabora]=false
valoriHash[:formato]="%-20s"
questoHash[:publisher_id] = valoriHash
#------- definisce una nuova componente di questoHash: vecchioid
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= 54321
valoriHash[:patt1]=%r{^(\d{1,5})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]= nil
valoriHash[:camposeq]='ID_UNBI'
valoriHash[:elabora]=false #true
valoriHash[:formato]="%6i"
questoHash[:vecchioid] = valoriHash
#------- definisce una nuova componente di questoHash: created_at
valoriHash = Hash.new
valoriHash[:type1]='datetime'
valoriHash[:type2]=' NOT NULL'
valoriHash[:valore]= 0.01
valoriHash[:patt1]=%r{(.*)}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=false
valoriHash[:formato]="%-20s"
questoHash[:created_at] = valoriHash
#------- definisce una nuova componente di questoHash: updated_at
valoriHash = Hash.new
valoriHash[:type1]='datetime'
valoriHash[:type2]=' NOT NULL'
valoriHash[:valore]= 0.01
valoriHash[:patt1]=%r{(.*)}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=false
valoriHash[:formato]="%-20s"
questoHash[:updated_at] = valoriHash
#------- definisce una nuova componente di questoHash: prezzoeurodec
valoriHash = Hash.new
valoriHash[:type1]='decimal'
valoriHash[:type2]=''
valoriHash[:valore]= 13.45
valoriHash[:patt1]=%r{^(\d{1,5},\d{0,2})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]= nil
valoriHash[:camposeq]='PREZZOLIRE'
valoriHash[:elabora]=true
valoriHash[:formato]="%6.2f"
questoHash[:prezzoeurodec] = valoriHash
#------- definisce una nuova componente di questoHash: copie
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= 12
valoriHash[:patt1]=%r{^(\d{0,3})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]='COPIE'
valoriHash[:elabora]=true
valoriHash[:formato]="%3i"
questoHash[:copie] = valoriHash

#------- definisce una nuova componente di questoHash: prezzoTCI (Totale Con Iva)
valoriHash = Hash.new
valoriHash[:type1]='decimal'
valoriHash[:type2]=''
valoriHash[:valore]= nil
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:lambda1]= nil
valoriHash[:camposeq]='---derivato---'
valoriHash[:elabora]=true
valoriHash[:formato]="%8.2f"
questoHash[:prezzoTCI] = valoriHash

#------- definisce una nuova componente di questoHash: prezzoTSI (Totale Senza Iva)
valoriHash = Hash.new
valoriHash[:type1]='decimal'
valoriHash[:type2]=''
valoriHash[:valore]= nil
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:lambda1]= nil
valoriHash[:camposeq]='---derivato---'
valoriHash[:elabora]=true
valoriHash[:formato]="%8.2f"
questoHash[:prezzoTSI] = valoriHash

#------- definisce una nuova componente di questoHash: deposito
valoriHash = Hash.new
valoriHash[:type1]='boolean'
valoriHash[:type2]=''
valoriHash[:valore]= "t"   # attenzione non passare true oppure false !!!
valoriHash[:patt1]=%r{^(VERO)}
valoriHash[:patt2]=%r{^(FALSO)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]='DEPOSITO'
valoriHash[:elabora]=false
valoriHash[:formato]="%6i"
questoHash[:deposito] = valoriHash
#------- definisce una nuova componente di questoHash: idaliquotaiva
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= 2
valoriHash[:patt1]=%r{^(\d{0,2})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]='IDALIQUOTAIVA'
valoriHash[:elabora]=true
valoriHash[:formato]="%2i"
questoHash[:iva] = valoriHash
#------- definisce una nuova componente di questoHash: iva (NO ATTRIBUTO MA DERIVATO)
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= 2
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:lambda1]=nil
valoriHash[:camposeq]='---'
valoriHash[:elabora]=false
valoriHash[:formato]="%1i"
questoHash[:idaliquotaiva] = valoriHash
#------- definisce una nuova componente di questoHash: url2
valoriHash = Hash.new
valoriHash[:type1]='varchar'
valoriHash[:type2]='(255)'
valoriHash[:valore]= "<<blabla>><<quiquo>>"
valoriHash[:patt1]=%r{^(.{1,70})}
valoriHash[:patt2]=%r{(.*)}
valoriHash[:lambda1]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=false
valoriHash[:formato]="%-20s"
questoHash[:url2] = valoriHash

#------- definisce una nuova componente di questoHash: annoedizione inserito il 21/10/2013
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= -1
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=false
valoriHash[:formato]=nil
questoHash[:annoedizione] = valoriHash

#------- definisce una nuova componente di questoHash: annomodifica inserito il 21/10/2013
valoriHash = Hash.new
valoriHash[:type1]='integer'
valoriHash[:type2]=''
valoriHash[:valore]= -1
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=false
valoriHash[:formato]=nil
questoHash[:annomodifica] = valoriHash

#------- definisce una nuova componente di questoHash: isbn inserito il 21/10/2013
valoriHash = Hash.new
valoriHash[:type1]='varchar'
valoriHash[:type2]='(255)'
valoriHash[:valore]= '1234567890123'
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:camposeq]=nil
valoriHash[:elabora]=false
valoriHash[:formato]=nil
questoHash[:isbn] = valoriHash


#------- definisce una nuova componente di questoHash: url2
valoriHash = Hash.new
valoriHash[:type1]='varchar'
valoriHash[:type2]='(255)'
valoriHash[:valore]= "e1987..m2012..1234567890123"  # 5+2+5+2+13 = 27
valoriHash[:patt1]=nil
valoriHash[:patt2]=nil
valoriHash[:camposeq]='---'
valoriHash[:elabora]=true
valoriHash[:formato]="%-27.27s"
questoHash[:edimodisb] = valoriHash

#pippo.scriviRiga("questoHash: #{questoHash.inspect}")
#=end
   return questoHash

end #def

