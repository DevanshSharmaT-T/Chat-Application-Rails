json.id @message.id
json.body @message.body
json.chat_id @message.chat_id
json.user_id @message.user_id
json.user_name @message.user.full_name
json.created_at @message.created_at
json.time_ago ActionController::Base.helpers.time_ago_in_words(@message.created_at)
