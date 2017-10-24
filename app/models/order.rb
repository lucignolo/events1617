class Order < ApplicationRecord
  	paginates_per 8
  	max_paginates_per 5	
	enum pay_type: {"Check" => 0, "Credit card" => 1, "Purchase order" => 2} 
end
