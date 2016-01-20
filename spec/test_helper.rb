# This is a helper file to render the test DRY

# Create an user
def create_user(save: true, data: { username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "KillBart" })
  user = User.new(data)
  user.save! if save
  yield user if block_given?
  user unless block_given?
end
