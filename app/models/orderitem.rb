class Orderitem < ApplicationRecord

	attr_accessor :current_user_id
	belongs_to :user
	belongs_to :item

    before_save :finalize

    validates :quantity, :user_id, :item_id, :chef_id, :runner_id, :presence => true, if: "User.find(self.current_user_id).role.eql?('admin')"

    validates :quantity, :presence => true

private
	def finalize
    	self[:total] = item.price * quantity
  	end

end
