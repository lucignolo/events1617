class Lbook < ApplicationRecord
	scope :gruppiIVA, -> { group("c14_idaliquotaiva").count }

	scope :tuttibase, -> { select("id, c01_vecchioid, c10_publisher_id") }
	scope :minid, -> { minimum(:id)}
	scope :maxid, -> { maximum(:id)}

	scope :minc01, -> { minimum(:c01_vecchioid)}	
	scope :maxc01, -> { maximum(:c01_vecchioid)}

    scope :minc10, -> { minimum(:c10_publisher_id)}
	scope :maxc10, -> { maximum(:c10_publisher_id)}

	#scope :tuttiIVA, -> { select("id, c01_vecchioid, c14_idaliquotaiva") }
	def self.badOpera()
		where c11_IDTIPOOPERA: NIL
	end #self-badOpera	
end
