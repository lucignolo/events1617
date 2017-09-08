require 'test_helper'

class BookTest < ActiveSupport::TestCase
	def test_empty_string
		mioB = Book.new()
		assert_equal({tutti: 0, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0}, mioB.aggiungi(:crea))
		assert_equal(0, mioB.aggiungi(:crea)[:tutti])
		assert_equal(0, mioB.aggiungi(:crea)[:bidoni])
		assert_equal(0, mioB.aggiungi(:crea)[:nonbidoni])
		assert_equal(0, mioB.aggiungi(:crea)[:sostituzioni2016])
	end

	def test_single_word
		mioB = Book.new()
		mioh = mioB.aggiungi(:crea)
		assert_equal({tutti: 10, bidoni: 0, nonbidoni: 0, sostituzioni2016: 0}, mioB.aggiungi(:tutti, mioh, 10))
		assert_nil(mioB.aggiungi(:nokey, mioh))
		assert_nil(mioB.aggiungi(:nokey, mioh, 123))
	end

	def test_miotestdiprova
		mioB = Book.new()
		mioh = mioB.aggiungi(:crea)
		assert_equal({tutti: 0, bidoni: 100, nonbidoni: 0, sostituzioni2016: 0}, mioB.aggiungi(:bidoni, mioh, 100))
		assert_equal({tutti: 0, bidoni: 100, nonbidoni: 1000, sostituzioni2016: 0}, mioB.aggiungi(:nonbidoni, mioh, 1000))
		assert_equal({tutti: 0, bidoni: 100, nonbidoni: 1000, sostituzioni2016: -9}, mioB.aggiungi(:sostituzioni2016, mioh, -9))
	end
end
