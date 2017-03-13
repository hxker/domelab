class Admin::AccountsController < AdminController
  skip_before_action :authenticate, only: [:new, :create, :destroy]
  layout 'admin_boot'

  def new
  end

  def index
    redirect_to '/admin/'
  end

  def create
    require 'geetest_sdk'
    challenge = params[:geetest_challenge] || ''
    validate = params[:geetest_validate] || ''
    sec_code = params[:geetest_seccode] || ''

    sdk = GeetestSDK.new(Settings.geetest_key)
    if params[:job_number].present?
      cookies[:job_number] = params[:job_number]
    end
    if sdk.validate(challenge, validate, sec_code)
      emp = Admin.find_by(job_number: params[:job_number])
      if emp.blank?
        flash[:error] = '工号不存在'
        render action: 'new'
      elsif not emp.auth_permissions(['admin', 'super_admin', 'teacher', 'audit', 'score', 'super_editor', 'editor'])
        flash[:error] = '此账号没有权限登录'
        render action: 'new'
      else
        status, message = emp.login(params[:password], request.remote_ip)
        if status
          flash[:notice] = message
          sing_in(emp)
          if cookies[:after_sign_in_return_to]
            redirect_to cookies[:after_sign_in_return_to]
          else
            redirect_to '/admin/'
          end
          cookies.delete :job_number
        else
          flash[:error] = message
          render action: 'new'
        end
      end
    else
      flash[:error] = '校验码不正确'
      render action: 'new'
    end
  end

  def destroy
    sing_out
    flash[:error] = '您已成功退出'
    redirect_to action: :new
  end

  def change_password
    render :layout => 'admin'
  end

  def change_password_post
    status, message = self.change_password_method(@current_admin, params[:password], params[:new_password], params[:confirm_password])

    if status
      sign_out
      flash[:error] = message
      redirect_to action: :new
    else
      flash[:error] = message
      redirect_to action: :change_password
    end
  end

  def change_password_method(current_admin, old_password, new_password, confirm_password)
    unless current_admin.present?
      return [FALSE, '用户不存在']
    end
    unless old_password.present?
      return [FALSE, '原密码不能为空']
    end
    unless new_password.length >= 6 && new_password.length <= 20
      return [FALSE, '请输入6-20位新密码']
    end
    unless new_password == confirm_password
      return [FALSE, '新密码两次输入不一致']
    end
    unless current_admin.authenticate(old_password)
      return [FALSE, '原密码不正确']
    end

    if current_admin.authenticate(old_password) && (current_admin.password = new_password; current_admin.save)
      [TRUE, '密码已成功修改，请重新登录']
    else
      [FALSE, '密码修改过程出错']
    end
  end


  private

  def sing_in(emp)
    cookies[:access_token] = emp.access_token
  end

  def sing_out
    cookies[:access_token] = nil
  end
end