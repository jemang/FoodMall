class Item < ApplicationRecord

	has_many :orderitems
	validates :name, :price, :note, :presence => true
	validates :price, :numericality => true
end
