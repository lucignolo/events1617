json.array!(@lbooks) do |lbook|
  json.extract! lbook, :id, :c01_vecchioid, :c02_titolo, :c03_prezzoeurodec, :c04_EDIZIONE, :c05_IDDISTRIBUTORE, :c06_IDSERIE, :c07_ISBN, :c08_copie, :c09_deposito, :c10_publisher_id, :c11_IDTIPOOPERA, :c12_ANNOEDIZIONE, :c13_note, :c14_idaliquotaiva, :c15_url2
  json.url lbook_url(lbook, format: :json)
end
