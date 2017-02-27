json.extract! orderitem, :id, :quantity, :note, :total, :status, :item, :user, :created_at, :updated_at
json.url orderitem_url(orderitem, format: :json)