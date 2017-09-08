require_relative 'aggiungi'
require 'test/unit'
class Basetest0 < Test::Unit::TestCase
	def ritorna_un_hash
	  assert_equal([], aggiungi())
	end
end	
