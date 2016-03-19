# This is a helper file to render the test DRY

# Create an user
def create_user(save: true, data: { username: "DonutLover", firstname: "Homer", lastname: "Simpson", email: "homer@contact.com" })
  user = User.new(data)

  user.password = data[:password].blank? ? "KillBart" :  data[:password]
  user.password_confirmation = data[:password].blank? ? user.password : data[:password]

  user.save! if save
  block_given? ? (yield user) : user
end
