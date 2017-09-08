#!/usr/local/bin/ruby
miorec = Book.find(11)
stringa = miorec.url2
prova = miorec.estraiAnnoDaUrl2(stringa)
p "#{prova.inspect}"