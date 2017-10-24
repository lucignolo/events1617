require 'test_helper'

class BookScopeTest < ActiveSupport::TestCase
	#self.use_transactional_tests = true

	fixtures :books

# inseriamo la versione attuale dell'Hash
provaHash = Hash(titolo:        Hash(ok: ["titolononbidone","titoloqualunque"], nok: ["titolobidone"]),
	             copie:         Hash(ok: [1, 2, 50]                           , nok: [0, -1]),
                 deposito:      Hash(ok: [false]                              , nok: [true]), 
                 prezzoeurodec: Hash(ok: [12.34]                              , nok: [-1.11, 500.1]),
                 annomodifica:  Hash(ok: [2000]                               , nok: [1999])
                )	

	def setup
       @book = books(:one)
       @quantiOK = Book.ammessiInventario2016.count
	end

	test "un test preliminare con nobidoni" do
		# assegno al record un titolo che NON soddisfa lo scope, ossia un titolo da bidone
		@book.update_attribute(:titolo, provaHash[:titolo][:nok][0])
		assert_equal("titolobidone", @book.titolo)
		#
	    quanti = Book.all.count
	    assert_equal(1, quanti)              # nella tabella esiste un record
	    #
	    noBidoni = Book.nobidoni.count
	    assert_equal(0, noBidoni)            # nella tabella esistono 0 record NON bidoni, dunque nessun record
	    #                                    # che soddisfi il nostro scope
	    @quantiOK = Book.ammessiInventario2016.count
	    assert_equal(0, @quantiOK)           # ok funziona
	end

	test "il vero test con ammessiInventario2016" do
		@book.update_attribute(:titolo, provaHash[:titolo][:nok][0])    # cambio il titolo con valore non ammesso da scope
		@quantiOK = Book.ammessiInventario2016.count
		assert_equal(0, @quantiOK)                                      # deve funzionare, come sopra
	end

	test "altra prova" do	
		@book = books(:one)
		@book.update_attribute(:titolo, provaHash[:titolo][:ok][0])     # cambio il titolo con un valore ammesso di mia scelta
		assert_equal("titolononbidone", @book.titolo) 
		noBidoni = Book.nobidoni.count
	    assert_equal(1, noBidoni)   
		#@book.save                                                      # verifico
	    #@quantiOK = Book.ammessiInventario2016.count                    # ora il risultato dello scope deve essere 1
	    assert_equal(1, Book.ammessiInventario2016.count)                # dato che l'unico record della tabella, dopo varie mod.
	                                                                     # è diventato, dopo la 42, un record ammissibile
	end	

	test "prova collettiva su copie nok e ok" do
		@book.update_attribute(:titolo, provaHash[:titolo][:ok][0])
		@book.update_attribute(:copie, provaHash[:copie   ][:ok][0])
		@book.update_attribute(:deposito, provaHash[:deposito][:ok][0])
		@book.update_attribute(:prezzoeurodec, provaHash[:prezzoeurodec][:ok][0])
		@book.update_attribute(:annomodifica, provaHash[:annomodifica][:ok][0])
		assert_equal(1, Book.ammessiInventario2016.count)
		#
		#@book.update_attribute(:copie, provaHash[:copie   ][:nok][0])
		#assert_equal(0, Book.ammessiInventario2016.count)
		#
		provaHash[:copie][:nok].each do |valore|
			@book.update_attribute(:copie, valore)
		    assert_equal(0, Book.ammessiInventario2016.count)
		end
		#
		provaHash[:copie][:ok].each do |valore|
			@book.update_attribute(:copie, valore)
		    assert_equal(1, Book.ammessiInventario2016.count)
		end
    end

    test "generale su tutti i valori di tutti i campi" do
        provaHash.each_pair do |campo, sh|
        	sh.each_pair do |tipo, valori|
        		valori.each_with_index do |valore, indice|
        			# assegno valore OK a tutti i campi
        			@book.update_attribute(:titolo, provaHash[:titolo][:ok][0])
		            @book.update_attribute(:copie, provaHash[:copie   ][:ok][0])
		            @book.update_attribute(:deposito, provaHash[:deposito][:ok][0])
		            @book.update_attribute(:prezzoeurodec, provaHash[:prezzoeurodec][:ok][0])
		            @book.update_attribute(:annomodifica, provaHash[:annomodifica][:ok][0])

		            # assegno il valore corrente al campo corrente
        			@book.update_attribute(campo, valore)
        			#
        			case tipo
        			when :ok
        				atteso = 1
        			when :nok
        				atteso = 0
        			end
                    assert_equal( atteso, Book.ammessiInventario2016.count)

        			#assert true #_true()   #assert_equal(@book.campo,provaHash[campo][tipo][])   <<< attenzione NON FINITO
        		end
        	end
        end
    end

end
