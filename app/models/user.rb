class User < ApplicationRecord

	has_secure_password

	has_many :orderitems
	validates :fullname, :username, :email, :address, :phone, :presence => true
	validates :email, :username, :uniqueness => true
	validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create}
	validates :password, confirmation: :true
	validates :phone, :length => { :minimum => 5, :maximum => 12 }

	
end
