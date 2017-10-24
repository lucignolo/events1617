require 'test_helper'

class BookZeroTest < ActiveSupport::TestCase
	def test_esterno1
		vera = Book.accediLibreriadiClasse
		risposta = "sono un metodo di classe! e restituisco il risultato di un altro metodo di clssse"
		atteso = risposta + "sono di classe!!"
        assert_equal(atteso, vera)
	end
end
