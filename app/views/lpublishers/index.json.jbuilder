json.array!(@lpublishers) do |lpublisher|
  json.extract! lpublisher, :id, :ID_EDITORE, :Nome
  json.url lpublisher_url(lpublisher, format: :json)
end
