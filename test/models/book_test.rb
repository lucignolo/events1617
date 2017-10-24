require 'test_helper'

class BookTest < ActiveSupport::TestCase
#	def test_empty_string
#		mioB = Book.new()
#		assert_equal({tutti: 0, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0}, mioB.aggiungi(:crea))
#		assert_equal(0, mioB.aggiungi(:crea)[:tutti])
#		assert_equal(0, mioB.aggiungi(:crea)[:bidoni])
#		assert_equal(0, mioB.aggiungi(:crea)[:nonbidoni])
#		assert_equal(0, mioB.aggiungi(:crea)[:sostituzioni2016])
#	end

#	def test_single_word
#		mioB = Book.new()
#		mioh = mioB.aggiungi(:crea)
#		assert_equal({tutti: 10, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0}, mioB.aggiungi(:tutti, mioh, 10))
#		assert_nil(mioB.aggiungi(:nokey, mioh))
#		assert_nil(mioB.aggiungi(:nokey, mioh, 123))
#	end

#	def test_miotestdiprova
#		mioB = Book.new()
#		mioh = mioB.aggiungi(:crea)
#		assert_equal({tutti: 0, bidoni: 100, nonbidoni: 0, sostituzioni2016: 0}, mioB.aggiungi(:bidoni, mioh, 100))
#		assert_equal({tutti: 0, bidoni: 100, nonbidoni: 1000, sostituzioni2016: 0}, mioB.aggiungi(:nonbidoni, mioh, 1000))
#		assert_equal({tutti: 0, bidoni: 100, nonbidoni: 1000, sostituzioni2016: -9}, mioB.aggiungi(:sostituzioni2016, mioh, -9))
#	end

#	def test_esterno1
#		vera = Book.accediLibreriadiClasse
#		risposta = "sono un metodo di classe! e restituisco il risultato di un altro metodo di clssse"
#		atteso = risposta + "sono di classe!!"
#       assert_equal(atteso, vera)
#	end

#	def test_daIDaIVA_indiretto 
#		vera = Book.provaprovaUgo0
#		atteso = "Hello, da provaUgo0 (NON in alcun module)"
#        assert_equal(atteso, vera)
#	end

	def test_daIDaIVA_negativo 
		vera = Book.chiamadaIDaIVA("-1")
		atteso = -9
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_0 
		vera = Book.chiamadaIDaIVA("0")
		atteso = -9
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_1 
		vera = Book.chiamadaIDaIVA("1")
		atteso = 4
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_2 
		vera = Book.chiamadaIDaIVA("2")
		atteso = 22
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_3 
		vera = Book.chiamadaIDaIVA("3")
		atteso = 0
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_4 
		vera = Book.chiamadaIDaIVA("4")
		atteso = 22
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_5 
		vera = Book.chiamadaIDaIVA("5")
		atteso = -9
        assert_equal(atteso, vera)
	end	

	def test_daIDaIVA_stringavuota 
		vera = Book.chiamadaIDaIVA("")
		atteso = -9
        assert_equal(atteso, vera)
	end		

	def test_daIDaIVA_conparametronil 
		vera = Book.chiamadaIDaIVA(nil)
		atteso = -9
        assert_equal(atteso, vera)
	end		

end
