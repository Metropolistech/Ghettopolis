class Api::V1::Me::UserController < Api::BaseController
  def index
    @user = current_user
  end

  def update
    if update_params
      return @user = current_user if current_user.update(update_params)
    end
    render_error
  end

  def destroy

  end

  private

  def update_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :is_admin)
    rescue
      nil
  end

  def render_error
    render json: { status: 404, errors: { message: "Cannot update user"} }, status: 404
  end
end
