def aggiungi(azione, hashdati = {}, valore = nil)
	if azione == :crea
		{k1:1, k2:2, k3:3}   #"azione era crea"	
	else
		if hashdati.has_key?(azione)
			#nuovovalore = hashdati[azione] + valore
			hashdati[azione] += valore
			return hashdati
		else
			return nil
		end
	end
end #aggiungi	
