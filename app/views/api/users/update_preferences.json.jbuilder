json.status @status_code
json.message @message

if @status_code == 200
  json.preferences do
    json.interests @user.interests
    json.preferences @user.preferences
  end
end
