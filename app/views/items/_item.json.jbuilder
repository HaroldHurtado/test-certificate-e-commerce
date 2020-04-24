json.extract! item, :id, :name, :description, :image_url, :price, :created_at, :updated_at
json.url item_url(item, format: :json)
