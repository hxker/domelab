class UserController < ApplicationController
  before_action :authenticate_user!

  # 个人信息概览
  def preview
    @user_info = User.where(id: current_user.id).left_joins(:school, :district).select(:email, :mobile, :nickname, :grade, :bj, 'schools.name', 'districts.name', :birthday, :username).take
  end

  # 修改个人信息
  def profile
    current_user_id = current_user.id
    @user_info = User.where(id: current_user_id).left_joins(:school, :district).select(:fullname, :email, :mobile, :nickname, :gender, :grade, :bj, :school_id, :district_id, 'schools.name as school_name', 'districts.name as district_name', :birthday).take
    @roles = Role.find_by_sql("select r.id,r.name,(select u_r.status from user_roles u_r where u_r.user_id = #{current_user_id} and u_r.role_id = r.id) as status from roles r")

    if request.method == 'POST'
      user_params = params[:user]
      if user_params.present?
        # 过滤Profile参数
        profile_params = params.require(:user).permit(:fullname, :school_id, :bj, :district_id, :gender, :birthday, :student_code, :identity_card, :cover, :grade)
        username = profile_params[:fullname]
        school_id = profile_params[:school_id]
        district_id = profile_params[:district_id]
        grade = profile_params[:grade]
        bj = profile_params[:bj]
        student_code = profile_params[:student_code]
        identity_card = profile_params[:identity_card]
        birthday = profile_params[:birthday]
        gender = profile_params[:gender]
        roles = user_params[:roles]
        desc_certificate = user_params[:desc_certificate]
        desc_family = user_params[:desc_family]
        cover = user_params[:cover]

        message = ''
        if roles.present?
          if roles.include?('教师')
            unless desc_certificate.present? && cover.present? && school_id.to_i != 0 && district_id.to_i != 0 && username.present? && [1, 2].include?(gender.to_i)
              flash[:error] = '选择教师身份时，请填写姓名、性别、学校(区县)、教师编号、和上传教师证件'
              return false
            end
            unless UserRole.where(user_id: current_user_id, role_id: 1).exists?
              th_role = UserRole.create(user_id: current_user_id, role_id: 1, status: 0, school_id: school_id, district_id: district_id, cover: cover, desc: desc_certificate) # 教师
              if th_role.save
                message = '您的老师身份已提交审核，审核通过后会在［消息］中告知您！'
              else
                message = '您的老师身份申请参数不规范'
              end
            end
          end
          if roles.include?('家庭创客')
            unless desc_family.present? && cover.present? && school_id.to_i != 0 && district_id.to_i != 0 && username.present? && [1, 2].include?(gender.to_i)
              flash[:error] = '选择家庭创客身份时，请填写姓名、性别、学校(区县)、简要描述和图片'
              return false
            end
            unless UserRole.where(user_id: current_user_id, role_id: 2).exists?
              th_role = UserRole.create(user_id: current_user_id, role_id: 2, status: 0, cover: cover, desc: desc_family, school_id: school_id, district_id: district_id) # 家庭创客
              if th_role.save
                message = '您的家庭创客身份已提交审核，审核通过后会在［消息］中告知您！'
              else
                message = '您的家庭创客身份申请参数不规范'
              end
            end
          end

        end


        if message=='-'
          message=''
        end

        if current_user.update_attributes(fullname: username, birthday: birthday, gender: gender, school_id: school_id, district_id: district_id, grade: grade, bj: bj, student_code: student_code, identity_card: identity_card)
          flash[:success] = '更新成功'+message
          redirect_to user_profile_path
        else
          flash[:error] = '更新失败'+message
        end
      else
        flash[:error] = '不能提交空信息'
      end

    end

  end

  def notifications
    @notifications = current_user.notifications.order('created_at desc').page(params[:page]).per(params[:per])
    if params[:id].present?
      @notification = Notification.find(params[:id])
    end
  end

  def notify_show
    @notification = current_user.notifications.find(params[:id])
  end

  def opus
    @opus = current_user.group_opus.joins(:group).select('group_opus.*', 'groups.name as group_name').page(params[:page]).per(params[:per])
  end

end
