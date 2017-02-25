class SessionsController < ApplicationController

	def new
		
	end

	def create
		user = User.find_by_email(params[:email])
		if user && User.find_by_password(params[:password])
			session[:user_id] = user.id
			if user.role.eql?("admin")
				redirect_to '/'
			elsif user.role.eql?("customer")
				redirect_to '/customer'
			else
				redirect_to '/login'
			end
		else
			redirect_to '/login'
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to '/login'
	end
end
