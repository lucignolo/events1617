json.array!(@publishers) do |publisher|
  json.extract! publisher, :id, :nome, :vecchioid
  json.url publisher_url(publisher, format: :json)
end
