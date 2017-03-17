class Item < ApplicationRecord

	has_many :orderitems
	has_many :users, through: :orderitems
	
	validates :name, :price, :presence => true
	validates :price, :numericality => true

	has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/missing.png"
	validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

end
