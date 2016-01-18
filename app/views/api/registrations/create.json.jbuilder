if @user.errors.present?
  json.errors @user.errors.messages
  json.response do
    json.code 422
  end
else
  json.response do
    json.code 201
  end
  json.data do
    json.user do
      json.id @user.id
      json.username @user.username
      json.email @user.email
    end
    json.token @auth_token
  end
end
