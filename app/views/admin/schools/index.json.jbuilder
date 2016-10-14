json.array!(@schools) do |school|
  json.extract! school,
  json.url school_url(school, format: :json)
end