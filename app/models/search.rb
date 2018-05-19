class Search < ApplicationRecord

	def self.latest
    Search.order(:updated_at).last
  end
end
