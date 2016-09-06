json.array!(@courses) do |c|
  json.extract! c,
  json.url course_url(c, format: :json)
end