json.array!(@books) do |book|
  json.extract! book, :id, :vecchioid, :titolo, :prezzoeurodec, :edizione, :isbn, :copie, :deposito, :publisher_id, :idtipoopera, :annoedizione, :note, :idaliquotaiva, :url2, :annomodifica
  json.url book_url(book, format: :json)
end
