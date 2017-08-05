class Publisher < ApplicationRecord
has_many :books

# giugno 2017: segue il gruppo di definizioni di scopes usati lo scorso anno
# 2016 per inventario 2015: il seguente scope (ambito) bidoni serve per contare i bidoni
	scope :tuttibase, -> { select("id, vecchioid, nome") }
	scope :maxid, -> { maximum("id")}
	scope :maxvecchioid, -> { maximum(:vecchioid) }
	# usseremo anche
	scope :bidoni, -> { where('nome LIKE "%nonono %"') }
	scope :gruppiVECCHIOID, -> { group("vecchioid").count }
	# nuovi scope 2017
	scope :nonbidoni, -> { where('nome not LIKE "%nono %"')}
# 26-28 giugno 2017 - Samone	
    scope :likeat, ->(parametro='%at%') { where("nome LIKE ?",parametro)}

	def self.creaSalvaNuovoRecord(numero, salvataggio)
		# metodo della classe Publisher - 17/06/2017
		bidone = Publisher.new
		bidone.nome = "nonono -#{numero}"
		bidone.vecchioid = numero
		if salvataggio
			bidone.save
		end
		return  "Inserito bidone in publishers: nome= #{bidone.nome}; vecchioid= #{bidone.vecchioid}."
	end #def creaSalvaNuovoRecord		
end
