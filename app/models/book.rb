class Book < ApplicationRecord
belongs_to :publisher
	
	scope :notlikeat, ->(parametro='%titolobidone%') { where("titolo NOT LIKE ?",parametro)}
	scope :likeat, ->(parametro='%titolobidone%') { where("titolo LIKE ?", parametro)}

	# 2016 per inventario 2015: il seguente scope (ambito) bidoni serve per contare i bidoni
	scope :bidoni, -> { where('titolo LIKE "%titolobidone"') }
	scope :nobidoni, -> { where('titolo NOT LIKE "%titolobidone"')}
    # ancora 2016 per inv. 2015: dallo scope che segue (omonimo del cugino in Lbook)
    # possiamo ottenere un hash con le frequenze dei diversi valori del campo idaliquotaiva
	scope :gruppiIVA, -> { group("idaliquotaiva").count }

	scope :tuttibase, -> { select("id, vecchioid, titolo, publisher_id") }
	scope :minid, -> { minimum(:id)}
	scope :maxid, -> { maximum(:id)}
	scope :minvid, -> { minimum(:vecchioid)}
	scope :maxvid, -> { maximum(:vecchioid)}

	scope :badTipoOpera, -> { group("idtipoopera").count }
	def self.badOpera(tipo)
		where("idtipoopera < ?", tipo)
	end #self-badOpera	
end
