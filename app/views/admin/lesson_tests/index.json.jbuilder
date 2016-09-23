json.array!(@lesson_tests) do |lesson_test|
  json.extract! lesson_test, :name
  json.url lesson_test_url(lesson_test, format: :json)
end