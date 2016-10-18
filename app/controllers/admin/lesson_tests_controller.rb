class Admin::LessonTestsController < AdminController
  before_action :set_lesson_test, only: [:show, :edit, :update, :destroy]
  before_action do
    authenticate_permissions(['super_admin', 'admin', 'teacher'])
  end
  # GET /admin/lesson_tests
  # GET /admin/lesson_tests.json
  def index
    lesson_tests = LessonTest.joins(:lesson).joins('left join courses c on c.id = lessons.course_id')
    if params[:field].present? && params[:keyword].present?
      lesson_tests = lesson_tests.where(["lesson_tests.#{params[:field]} like ?", "%#{params[:keyword]}%"])
    end
    @lesson_tests = lesson_tests.select(:id, :name, :option_1, :option_2, :option_3, :option_4, :answer, 'lessons.name as lesson_name', 'c.name as course_name').order('lesson_tests.lesson_id').page(params[:page]).per(params[:per])
  end

  # GET /admin/lesson_tests/1
  # GET /admin/lesson_tests/1.json
  def show
    @lesson_info = Lesson.joins(:course).where(id: @lesson_test.lesson_id).select(:name, 'courses.name as course_name').take
  end

  # GET /admin/lesson_tests/new
  def new
    @lesson_test = LessonTest.new
  end

  # GET /admin/lesson_tests/1/edit
  def edit
    @lessons = Lesson.find_by_sql("select l.id,CONCAT(c.name,'--',l.name ) as name from lessons l left join courses c on l.course_id = c.id where l.course_id = #{@lesson_test.lesson.course_id}")
  end

  # POST /admin/lesson_tests
  # POST /admin/lesson_tests.json
  def create
    @lesson_test = LessonTest.new(lesson_test_params)

    respond_to do |format|
      if @lesson_test.save
        format.html { redirect_to [:admin, @lesson_test], notice: '创建成功' }
        format.json { render action: 'show', status: :created, location: @lesson_test }
      else
        format.html { render action: 'new' }
        format.json { render json: @lesson_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/lesson_tests/1
  # PATCH/PUT /admin/lesson_tests/1.json
  def update
    respond_to do |format|
      if @lesson_test.update(lesson_test_params)
        format.html { redirect_to [:admin, @lesson_test], notice: '更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lesson_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/lesson_tests/1
  # DELETE /admin/lesson_tests/1.json
  def destroy
    if @lesson_test.destroy
      @notice = [true, '删除成功', @lesson_test.id]
    else
      @notice = [false, '删除失败']
    end
    respond_to do |format|
      format.html { redirect_to admin_lesson_tests_url, notice: '删除成功!' }
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson_test
    @lesson_test = LessonTest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_test_params
    params.require(:lesson_test).permit!
  end

  # def get_course_lesson
  #   Lesson.find_by_sql("select l.id,CONCAT(c.name,':',l.name) as name from lessons l left join courses c on c.id=l.course_id order by c.id")
  # end

end