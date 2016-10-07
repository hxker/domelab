class Admin::GroupsController <AdminController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :students]
  before_action do
    authenticate_permissions(['super_admin', 'admin'])
  end
  # GET /admin/groups
  # GET /admin/groups.json
  def index
    groups = Group.left_joins(:teacher)
    if params[:field].present? && params[:keyword].present?
      groups = groups.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"])
    end
    @groups = groups.select('groups.*', 'admins.name as teacher_name').page(params[:page]).per(params[:per])
  end

  # GET /admin/groups/1
  # GET /admin/groups/1.json
  def show
    @has_courses = @group.group_course_ships.left_joins(:course).pluck(:id, 'courses.name')
    if Date.today < @group.end_date
      @courses = Course.select(:id, :name)
    end

  end

  def get_schedule
    result = GroupSchedule.where(group_id: params[:group_id]).select(:id, :title, :start, :end, :allDay)
    render json: result
  end

  def add_schedule
    if request.method == 'GET'
      @group = Group.find(params[:id])
    end
    if request.method == 'POST'
      group_id = params[:group_id]
      lesson_id = params[:lesson_id]
      title = params[:title]
      start_time = params[:start]
      end_time = params[:end]
      all_day = params[:allDay]
      g_s = GroupSchedule.create(group_id: group_id, lesson_id: lesson_id, title: title, start: start_time, end: end_time, allDay: all_day)
      if g_s.save
        result = [true, '添加成功', g_s.id]
      else
        result = [false, '添加失败']
      end
      render json: result
    end
  end

  def update_schedule
    event = params[:event]

    if event[:id].present? && event.present?
      g_s = GroupSchedule.where(id: event[:id]).first
      if g_s.present?
        if g_s.update_attributes(title: event[:title], start: event[:start], end: event[:end], allDay: event[:allDay])
          result = [true, '更新成功']
        else
          result = [false, '更新失败']
        end
      else
        result = [false, '参数不规范']
      end
    else
      result = [false, '参数不完整']
    end
    render json: result
  end

  def delete_schedule
    id = params[:id]
    if id.present?
      g_s = GroupSchedule.where(id: id).first
      if g_s.present? && g_s.destroy
        result = [true, '删除成功']
      else
        result = [false, '删除失败']
      end
    else
      result = [false, '参数不完整']
    end
    render json: result
  end

  def add_course
    group_id = params[:group_id]
    course_ids = params[:course_ids]

    if group_id && course_ids.present? && course_ids.is_a?(Array) && (course_ids.length < 4) && Group.exists?(group_id)
      status = []
      course_ids.each do |c|
        g_c = GroupCourseShip.create(group_id: group_id, course_id: c)
        unless g_c.save
          status << false
        end
      end
      if status.length > 0
        result = [false, "有#{status.length}个课程添加失败"]
      else
        result = [true, '添加成功']
      end
    else
      result = [false, '参数不规范']
    end
    render json: result
  end

  def delete_course
    group_id = params[:group_id]
    group_course_id = params[:group_course_id]
    g_c = GroupCourseShip.where(id: group_course_id).joins(:group).select(:id, :group_id, 'groups.end_date').first

    if g_c && (g_c.end_date > Date.today) && (g_c.group_id == group_id.to_i)
      if g_c.destroy
        result = [true, '删除成功']
      else
        result = [false, '删除失败']
      end
    else
      result = [false, '不规范操作']
    end
    render json: result
  end

  def students
    @users = @group.group_user_ships.joins(:user).where(status: 1).select(:id, 'users.fullname', 'users.id as user_id', 'users.student_code', 'users.mobile', 'users.email').page(params[:page]).per(params[:per])
  end

  # GET /admin/groups/new
  def new
    @group = Group.new
  end

  # GET /admin/groups/1/edit
  def edit
  end

  # POST /admin/groups
  # POST /admin/groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to [:admin, @group], notice: t('activerecord.models.group') + '创建成功!' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/groups/1
  # PATCH/PUT /admin/groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to [:admin, @group], notice: t('activerecord.models.group') +'更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/groups/1
  # DELETE /admin/groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to admin_groups_url, notice: t('activerecord.models.group') +'删除成功!' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit!
  end

end