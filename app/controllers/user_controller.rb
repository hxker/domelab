class UserController < ApplicationController
  before_action :authenticate_user!

  # 个人信息概览
  def preview
    @user_info = current_user
  end

  # 修改个人信息
  def profile

  end

end
