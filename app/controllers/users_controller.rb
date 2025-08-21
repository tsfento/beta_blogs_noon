class UsersController < ApplicationController
  def create
    result = UserService::Base.create_user(user_params)

    if result.success?
      render_success(payload: UserBlueprint.render_as_hash(result.payload, view: :normal), status: :created)
    else
      render_error(errors: result.errors, status: :unprocessable_entity)
    end
  end

  private

  def user_params
    params.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation)
  end
end
