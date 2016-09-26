class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @courses = Course.where(course_type: 1, status: 1).select(:id, :name)
  end

  def show
    course_id = params[:id]
    @course = Course.joins(:group_course_ships).joins('left join group_user_ships g_u on g_u.group_id = group_course_ships.group_id').where(id: course_id).where('g_u.user_id=?', current_user.id).select(:id, :name, :cover, :course_info).take
    if @course
      @lessons = Lesson.where(course_id: course_id)
      @stars = @course.course_stars.select(:name, :stars)
    else
      render_optional_error(404)
    end

  end

  def dome
    current_user_id = current_user.id
    @group_user = Group.joins(:group_user_ships).left_joins(:teacher).where('group_user_ships.user_id = ?', current_user_id).where('groups.end_date > ?', Date.today).select('group_user_ships.status as ship_status', 'groups.*', 'admins.name as teacher_name', 'admins.avatar').take
    if @group_user.present?
      @has_sign_in = SignIn.where(user_id: current_user_id).where('updated_at > ?', Time.now.midnight).exists?
      @group_courses = @group_user.courses.select(:id, :name, :cover)
    else
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

  def schedule
    group_id = params[:id]
    if group_id.present? && GroupUserShip.where(group_id: group_id, user_id: current_user.id).exists?
      group = Group.find(group_id)
      @group_schedules = group.group_schedules
    else
      render_optional_error(404)
    end
  end

  def sign_in
    current_user_id = current_user.id
    sign_in = SignIn.find_by_user_id(current_user_id)
    if sign_in
      time_now = Time.now
      today_dawn = time_now.midnight

      if sign_in.updated_at > today_dawn
        @result = [false, '今天你已签到']
      else
        if sign_in.updated_at > (today_dawn-1.day)
          sign_in.continuous_days += 1
        end
        sign_in.updated_at = time_now
        sign_in.sign_count += 1
        if sign_in.save
          @result = [true, '签到成功']
        else
          @result = [false, '签到失败']
        end
      end
    else
      new_sign_in = SignIn.create(user_id: current_user_id)
      if new_sign_in.save
        @result = [true, '签到成功']
      else
        @result = [false, '签到失败']
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def lesson_test
    lesson_id = params[:id]
    if lesson_id.present? && check_group_user(lesson_id)
      @tests = LessonTest.where(lesson_id: lesson_id)
    else
      render_optional_error(404)
    end
  end

  def check_lesson_test
    lesson_id = params[:lesson_id]
    answers = params[:answers].to_unsafe_h
    if lesson_id && check_group_user(lesson_id)
      if current_user.user_lesson_tests.where(lesson_id: lesson_id).exists?
        result = [false, '您已做过该测试']
      else
        tests = LessonTest.where(lesson_id: lesson_id)
        test_keys = tests.pluck(:id).map { |x| x.to_i }
        answers_keys = answers.keys
        if tests && tests.length == answers.length && (test_keys == answers_keys)
          right_per = []
          tests.each do |test|
            right_per << true if test["option_#{test.answer}"] == answers["#{test.id}"]
          end
          result = [true, (Float(right_per.length)/tests.length)]
        else
          result = [false, '答案不完整']
        end

      end
    else
      render_optional_error(404)
    end

    render json: result
  end

  private

  def check_group_user(lesson_id)
    GroupCourseShip.left_j_lesson.left_j_group_user.where('l.id=?', lesson_id).where('g_u.user_id=?', current_user.id).exists?
  end
end