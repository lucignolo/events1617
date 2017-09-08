require_relative 'words_from_string'
require 'test/unit'
class TestWordsFromString < Test::Unit::TestCase
	def test_empty_string
	assert_equal("prova", words_from_string("prova"))
	assert_equal("PROVA", words_from_string("PROVA "))
	end
end	