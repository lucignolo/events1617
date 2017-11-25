#!/usr/local/bin/ruby
# (enkoding: WINDOWS-1252)
y=sprintf("%1$*2$s %2$d %1$s", "hello", 8)
puts y
z =sprintf("%1$*2$s %2$d", "hello", -8)
puts z
formatx = "%1$*2$s %2$d %1$s"
y=sprintf(formatx, "hello", 8)
puts y
#-----------
form0 = "%-33.30s%3d %3d"
puts form0
nome = "Nome primo editore lungo abbastanza lungo"
legati = 23
ammessi = 12
ris = sprintf(form0,nome,legati, ammessi)
lris = ris.size
puts "#{ris}......#{lris}"

nome = "Nome corto"
legati = 123
ammessi = 2
ris = sprintf(form0,nome,legati, ammessi)
lris = ris.size
puts "#{ris}......#{lris}"