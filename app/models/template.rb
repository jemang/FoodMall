class Template < ApplicationRecord
  belongs_to :user
  belongs_to :item

  before_save :finalize

  validates :quantity, :dtime, :day, :user_id, :runner_id, :chef_id, :item_id, :presence => true

  private
	def finalize
    	self[:total] = item.price * quantity
  	end

end
