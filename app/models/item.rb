class Item < ApplicationRecord

	has_many :orderitems
	validates :name, :price, :presence => true
	validates :price, :numericality => true
end
