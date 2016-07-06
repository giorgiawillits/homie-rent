json.array!(@charges) do |charge|
  json.extract! charge, :id, :completed, :amount
  json.url charge_url(charge, format: :json)
end
