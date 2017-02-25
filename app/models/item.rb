class Item < ApplicationRecord

	validates :name, :price, :note, :presence => true
	validates :price, :numericality => true
end
