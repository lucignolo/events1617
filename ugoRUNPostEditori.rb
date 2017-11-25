#!/usr/local/bin/ruby
# (enkoding: WINDOWS-1252)
# ugoRUNPostEditori modificato il 14/11/2017
RIGA_PRIMO_EDITORE  = 52
RIGA_ULTIMO_EDITORE = 1143
#QUANTI_DA_FARE = 2000

outPresenti = []
outAssenti  = []

def pulisciStampa(stringa, outPresenti, outAssenti)
	riga = stringa.chomp[10,90]
	formP = "%-33.30s%3d %3d"
	formA = "%-36.33s%3d"
	#puts riga
	# cerchiamo il titolo e il numero dei legati e deigli ammessi in riga
	prefLegati = /(.+)-\scon\s(\d+)\s(.+)di\scui\s(\d+)/
	match = prefLegati.match(riga)
	nomeEditore = match[1]
	numeroBookAmmessi = match[4].to_i
	numeroBookLegati = match[2].to_i
	testo ="#{nomeEditore}::#{numeroBookLegati}::#{numeroBookAmmessi}"
	#puts "#{match[1]};#{numeroBookLegati};#{numeroBookAmmessi};"
	puts testo
	# swith in base al numeroBookAmmessi	
	if numeroBookAmmessi > 0
		#rigona = "#{nomeEditore} --#{numeroBookLegati} --#{numeroBookAmmessi} ."
		rigona = sprintf(formP, nomeEditore, numeroBookLegati, numeroBookAmmessi)
		outPresenti << rigona
	else
		rigona = sprintf(formA,nomeEditore, numeroBookLegati)
		outAssenti << rigona
	end
end #def pulisciStampa(stringa)

# --- esegue
titolo1  = "ugoRUNPosteEditori.rb legge da outrunner2.txt "
titolo1 += "a partire dalla riga #{RIGA_PRIMO_EDITORE} "
titolo1 += "fino alla riga #{RIGA_ULTIMO_EDITORE} "
#titolo1 += "per un totale di #{QUANTI_DA_FARE} righe."
puts titolo1
#
File.open("outrunner2.txt", "r") do |file|
# ... process the file
    #matchPrincipale = /^[0-9]{3}\|\s\*\s\s/
	i=0
	while line = file.gets
		i += 1
		#matchP = matchPrincipale.match(line)
		if  i < RIGA_PRIMO_EDITORE || i > RIGA_ULTIMO_EDITORE
			# non fare
		else

			# scrive la la riga letta se standard all'inizio e anche alla fine
			patternStart = /^[0-9]{3}\|\s/
			matchStart = patternStart.match(line)
			patternEnd = /\sammessi\Z/
			matchEnd = patternEnd.match(line)
			if matchStart && matchEnd
				pulisciStampa(line, outPresenti, outAssenti)
			else
				salvaRiga = line.chomp
				nuova = file.gets.chomp
				finale = salvaRiga + nuova[5,30]
				pulisciStampa(finale, outPresenti, outAssenti)
				i += 1
			end             	
		end	
		#break if i>QUANTI_DA_FARE
	end
end

quanti = outPresenti.size
puts "- - - inseriti #{quanti} nel file outPresenti.txt"
File.open("outPresenti.txt", "w") do |file|
	(0..quanti-1).each do |iriga|
		file.puts  outPresenti[iriga]
	end	 
end

quanti = outAssenti.size
puts "- - - inseriti #{quanti} nel file outAssenti.txt"
File.open("outAssenti.txt", "w") do |file|
	(0..quanti-1).each do |iriga|
		file.puts  outAssenti[iriga]
	end	 
end
