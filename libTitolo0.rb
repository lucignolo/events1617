class Titolo
  attr_reader :titolo
  def initialize(stringa, massima)
    @titolo = stringa
    @tronconi = []
    @mASSIMA = massima
  end
  
  def vaiRighe(log)
  end
  
  def spezza(tit,log)
  ltit = tit.size
  if ltit <= @mASSIMA
    @tronconi << tit.lstrip
    ritorno = true
    return ritorno
  end
  primo = tit[0, @mASSIMA-1]
  resto = tit[@mASSIMA-1, ltit]
  #log.debug("primo: #{primo}")
  #log.debug("resto: #{resto}")
  i=primo.size-1
  testa = ""
  esci = false
  while i >=0 && !esci
  cara=primo[i]
  #log.debug("i: #{i}  cara: #{cara}")
  if cara == " "
    testa += cara
    riga1 = primo[0,i]
    @tronconi << riga1.lstrip
    riga2 = testa.reverse+resto
    #log.debug("riga1:#{riga1};  riga2:#{riga2}.")
    ritorno = true
    esci = true
  else
    testa += cara
  end #if cara
  i -= 1
  if i <= 0
    log.debug("impossibile trovare un blank nella stringa: #{primo}")
    ritorno = false
    esci = true
  end #if i
end #while
if ritorno
  lriga2 = riga2.size
  if lriga2 > @mASSIMA && ritorno
  ritorno = spezza(riga2,log)
  else
  @tronconi << riga2.lstrip
  end #if lriga2
  return ritorno
else
  return ritorno
end # if ritorno
end #def
  
  def getTronconi
    @tronconi
  end #def getTronconi
  
end #class Titolo
