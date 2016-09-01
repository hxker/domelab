class Admin::ChecksController < AdminController

  before_action do
    authenticate_permissions(['admin'])
  end

  def teachers
    @teachers= UserRole.left_joins(:user, :school, :district).where(role_id: 1, status: 0).select(:id, :cover, :user_id, :desc, 'schools.name as school_name', 'districts.name as district_name', 'users.mobile', 'users.fullname', 'users.gender').page(params[:page]).per(params[:per])
    @teacher_array = @teachers.map { |c| {
        id: c.id,
        user_id: c.user_id,
        district: c.district_name,
        school: c.school_name,
        mobile: c.mobile,
        num: c.desc,
        username: c.fullname,
        gender: c.gender,
        certificate: c.cover.present? ? ActionController::Base.helpers.asset_path(c.cover_url(:large)) : nil
    } }
  end

  def review_teacher
    level = params[:level]
    status = params[:status].to_i
    ud = params[:ud]
    if status.present? && ud.present?
      ur = UserRole.where(user_id: ud, role_id: 1).take
      if ur.present?
        ur.status = status==1 ? true : false

        if status==1 && level.present? && ([level.to_i] & [1, 2, 3, 4, 5]).length>0
          ur.role_type = level
        else
          render json: [false, '请选择教师角色']
          return false
        end
        if ur.save
          case ur.role_type
            when 1 then
              th_level = '市级'
            when 2 then
              th_level = '区级(审核比赛队伍)'
            when 3 then
              th_level = '校级(审核比赛队伍)'
            when 4 then
              th_level = '区级'
            else
              th_level = '校级'
          end
          # Notification.create(user_id: ur.user_id, content: '您的教师身份审核'+(status==1 ? '通过! 角色为'+th_level : '未通过!'), message_type: 0)
          result = [true, '操作成功，即将推送消息告知被审核用户']
        else
          result = [false, ur.errors.full_messages.first]
        end
      else
        result = [false, '该教师角色不存在']
      end
    else
      result = [false, '数据不完整']
    end
    render json: result
  end

  def teacher_list
    @teachers = UserRole.joins(:user, :school).where(role_id: 1, status: 1).select(:id, :user_id, :desc, :school_id, :role_type, :cover, 'schools.name as school_name', 'users.fullname', 'users.gender', 'users.mobile').page(params[:page]).per(params[:per])
    @teacher_array = @teachers.map { |c| {
        id: c.id,
        user_id: c.user_id,
        school: c.school_name,
        mobile: c.mobile,
        num: c.desc,
        username: c.fullname,
        gender: c.gender,
        role: c.role_type,
        certificate: c.cover.present? ? ActionController::Base.helpers.asset_path(c.cover_url) : nil
    } }
  end

  def hackers
    @hackers = UserRole.left_joins(:user, :school, :district).where(role_id: 2).where(status: 0)
                   .select(:id, :cover, :desc, 'schools.name as school_name', 'districts.name as district_name', 'users.fullname', 'users.gender').page(params[:page]).per(params[:per])
    @hackers_array = @hackers.map { |c| {
        id: c.id,
        username: c.fullname,
        gender: c.gender,
        school: c.school_name,
        district: c.district_name,
        desc: c.desc,
        cover: c.cover.present? ? ActionController::Base.helpers.asset_path(c.cover_url) : nil
    } }
  end

  def hacker_list
    @hackers = UserRole.left_joins(:user, :school, :district).where(role_id: 2).where(status: 1)
                   .select(:id, :cover, :desc, 'schools.name as school_name', 'districts.name as district_name', 'users.fullname', 'users.gender').page(params[:page]).per(params[:per])
    @hackers_array = @hackers.map { |c| {
        id: c.id,
        username: c.fullname,
        gender: c.gender,
        school: c.school_name,
        district: c.district_name,
        desc: c.desc,
        cover: c.cover.present? ? ActionController::Base.helpers.asset_path(c.cover_url) : nil
    } }
  end

  def review_hacker
    status = params[:status]
    id = params[:id]
    if status.present?
      ur = UserRole.find(id)
      if ur.present?
        if status == '1'
          ur.status = 1
          if ur.save
            # Notification.create!(user_id: ur.user_id, content: '您的家庭创客身份审核'+(status=='1' ? '通过!' : '未通过!'), message_type: 0)
            result = [true, '操作成功，即将推送消息告知被审核用户']
          else
            result = [false, '操作失败']
          end
        elsif status == '0'
          ur.delete
          # Notification.create!(user_id: ur.user_id, content: '您的家庭创客身份审核'+(status=='1' ? '通过!' : '未通过!'), message_type: 0)
          result = [true, '操作成功，即将推送消息告知被审核用户']
        else
          result = [false, '不规范参数']
        end
      else
        result = [false, '该角色不存在']
      end
    else
      result = [false, '请选择审核结果']
    end
    render json: result
  end

end
