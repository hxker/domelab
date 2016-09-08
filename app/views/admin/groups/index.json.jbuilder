json.array!(@groups) do |c|
  json.extract! c,
  json.url group_url(c, format: :json)
end