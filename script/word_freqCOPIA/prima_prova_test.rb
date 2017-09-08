require_relative 'aggiungi_sorgente'
require 'test/unit'
class TestPrimaProva < Test::Unit::TestCase
	
	def test_empty_string
		assert_equal({k1:1, k2:2, k3:3}, aggiungi(:crea))
		assert_equal(1, aggiungi(:crea)[:k1])
		assert_equal(3, aggiungi(:crea)[:k3])
	end
	def test_single_word
		mioh = aggiungi(:crea)
		assert_equal({k1:2, k2:2, k3:3}, aggiungi(:k1, mioh, 1))
		assert_nil(aggiungi(:k4, mioh))
		assert_nil(aggiungi(:k5, mioh, 123))
	end

	def test_miotestdiprova
		mioh = aggiungi(:crea)
		assert_equal({k1:1, k2:3, k3:3}, aggiungi(:k2, mioh, 1))
		assert_equal({k1:1, k2:3, k3:4}, aggiungi(:k3, mioh, 1))
	end
end	