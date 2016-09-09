json.array!(@lessons) do |c|
  json.extract! c,
  json.url lesson_url(c, format: :json)
end