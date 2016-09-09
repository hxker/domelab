class Admin::LessonsController < AdminController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action do
    authenticate_permissions(['super_admin', 'admin'])
  end

  # GET /admin/lessons
  # GET /admin/lessons.json
  def index
    field = params[:field]
    keyword = params[:keyword]
    lessons = Lesson.joins(:course)
    if field.present? && keyword.present?
      if field == 'course_id'
        lessons = lessons.where(['courses.name like ?', "%#{keyword}%"])
      else
        lessons = lessons.where(["lessons.#{field} like ?", "%#{keyword}%"])
      end
    end
    @lessons = lessons.select('lessons.*', 'courses.name as course_name').page(params[:page]).per(params[:per])
  end

  # GET /admin/lessons/1
  # GET /admin/lessons/1.json
  def show
  end

  # GET /admin/lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /admin/lessons/1/edit
  def edit
  end

  # POST /admin/lessons
  # POST /admin/lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to [:admin, @lesson], notice: t('activerecord.models.lesson') + '创建成功!' }
        format.json { render action: 'show', status: :created, location: @lesson }
      else
        format.html { render action: 'new' }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/lessons/1
  # PATCH/PUT /admin/lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to [:admin, @lesson], notice: t('activerecord.models.lesson') +'更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/lessons/1
  # DELETE /admin/lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to admin_lessons_url, notice: t('activerecord.models.lesson') +'删除成功!' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_params
    params.require(:lesson).permit!
  end
end