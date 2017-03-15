class Orderitem < ApplicationRecord

	belongs_to :user
	belongs_to :item

    before_save :finalize

    #validates :quantity, :dtime, :presence => true

private
	def finalize
    	self[:total] = item.price * quantity
  	end

end
