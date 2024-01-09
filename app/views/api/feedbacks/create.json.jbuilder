json.set! :status, 201
json.set! :message, "Feedback submitted successfully."

json.feedback do
  json.id @feedback.id
  json.user_id @feedback.user_id
  json.match_id @feedback.match_id
  json.comment @feedback.comment
end
