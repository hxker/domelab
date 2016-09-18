class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @courses = Course.where(course_type: 1, status: 1).select(:id, :name)
  end

  def dome
    @group_user = Group.joins(:group_user_ships).left_joins(:teacher).where('group_user_ships.user_id = ?', current_user.id).where('groups.end_date > ?', Date.today).select(:user_id, 'group_user_ships.status as ship_status', 'groups.*', 'users.fullname').take
    unless @group_user.present?
      @groups = Group.where(status: 1).select(:id, :name)
    end
  end

  def apply_group
    group_id = params[:user][:select_group]
    username = params[:user][:fullname]
    student_code = params[:user][:student_code]
    current_user_id = current_user.id
    if group_id.present? && username.present? && student_code.present?
      group = Group.find(group_id)
      if group && (group.end_date > Time.now)
        if GroupUserShip.where(user_id: current_user_id, group_id: group_id).exists?
          flash[:error] = '您已是该班级学生,无需再次申请'
        else
          if current_user.update(fullname: username, student_code: student_code)
            g_u = GroupUserShip.create(user_id: current_user_id, group_id: group_id, status: false)
            if g_u.save
              flash[:success] = '申请成功,审核结果将通过消息推送告知您!'
            else
              flash[:error] = '申请失败!'
            end
          else
            flash[:error] = '参数不规范'
          end
        end
      else
        flash[:error] = '该班级已结业 或 不规范操作'
      end
    else
      flash[:error] = '请将班级、姓名、学籍号填写完整'
    end
    redirect_to '/courses/dome'
  end
end