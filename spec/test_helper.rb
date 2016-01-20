# This is a helper file to render the test DRY

# Create an user
def create_user
  @user = User.create(username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "KillBart")
  yield if block_given?
end
