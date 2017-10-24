require 'test_helper'

class BookScopeTest < ActiveSupport::TestCase
	fixtures :books

	def setup
       @book = books(:one)
       @due  = books(:two)
       @tre  = books(:three)
	end

	test "un test preliminare con nobidoni" do
		@book.titolo = "titolobidone"
		@book.update_attribute(:titolo, "titolobidone")
		assert_equal("titolobidone", @book.titolo)
		#
	    quanti = Book.all.count
	    assert_equal(3, quanti)
	    #
	    noBidoni = Book.nobidoni.count
	    assert_equal(2, noBidoni)
	end

	test "il vero test con ammessiInventario2016 coin o senza prezzo" do
		@tre.update_attribute(:deposito, 'f')
		assert_equal(false, @tre.deposito)
	    #
        nAmmessi = Book.ammessiInventario2016.count
	    #assert_equal(3, nAmmessi)
	    #
	    @tre.update_attribute(:copie, 0)
	    assert_equal(nAmmessi-1, Book.ammessiInventario2016.count)
	end	

	test "il test con ammessiInventario2016 versione con prezzo" do
        nAmmessi = Book.ammessiInventario2016.count
	    assert_equal(2, nAmmessi)
	    #
	    @book.update_attribute(:prezzoeurodec, -1.0)
	    nAmmessi = Book.ammessiInventario2016.count
	    assert_equal(1, nAmmessi)
	    #
		@book.update_attribute(:prezzoeurodec, 500.1)
	    nAmmessi = Book.ammessiInventario2016.count
	    assert_equal(1, nAmmessi)
	    #	    
	end		

	test "ammessiInventario2016 versione con annomodifica" do
        nAmmessiBase = Book.ammessiInventario2016.count
	    #
	    @book.update_attribute(:annomodifica, 2000)
	    nAmmessiOra = Book.ammessiInventario2016.count
	    assert_equal(nAmmessiBase+1, nAmmessiOra)
	    #
	    #	    
	end			
end
