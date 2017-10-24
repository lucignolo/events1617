def daIDaIVA(id)
    #converte un idaliquotaIVA nel valore dell'IVA
    #modifiche del 26 ottobre 2014 per consentire il valore 4 come indice (con iva=22)
    #                 e estensione di tale valore anche all'indice 2
    veraiva = Hash[ "1" => 4, "2" => 22, "3" => 0, "4" => 22]
    return -9 if !(1..4).include?(id.to_i)
    questaIVA = veraiva[id.to_s]
    #@@log.debug("::::::::::::daIDaIVA: #{id.inspect} -- #{veraiva.inspect}-- #{questaIVA}")
    return questaIVA
end #def