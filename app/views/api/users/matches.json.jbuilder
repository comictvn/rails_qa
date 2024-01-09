json.status 200
json.matches @matches do |match|
  json.extract! match, :id, :age, :gender, :location, :interests
  json.compatibility_score match.compatibility_score
end
