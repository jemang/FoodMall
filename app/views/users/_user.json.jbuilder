json.extract! user, :id, :fullname, :username, :email, :role, :address, :password, :phone, :created_at, :updated_at
json.url user_url(user, format: :json)