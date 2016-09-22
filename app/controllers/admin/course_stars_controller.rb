class Admin::CourseStarsController < AdminController
  before_action :set_course_star, only: [:show, :edit, :update, :destroy]

  # GET /admin/course_stars
  # GET /admin/course_stars.json
  def index
    if params[:field].present? && params[:keyword].present?
      @course_stars = CourseStar.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @course_stars = CourseStar.all.page(params[:page]).per(params[:per])
    end

  end

  # GET /admin/course_stars/1
  # GET /admin/course_stars/1.json
  def show
  end

  # GET /admin/course_stars/new
  def new
    @course_star = CourseStar.new
  end

  # GET /admin/course_stars/1/edit
  def edit
  end

  # POST /admin/course_stars
  # POST /admin/course_stars.json
  def create
    @course_star = CourseStar.new(course_star_params)

    respond_to do |format|
      if @course_star.save
        format.html { redirect_to [:admin, @course_star], notice: '创建成功' }
        format.json { render action: 'show', status: :created, location: @course_star }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @course_star.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /admin/course_stars/1
  # PATCH/PUT /admin/course_stars/1.json
  def update
    respond_to do |format|
      if @course_star.update(course_star_params)
        format.html { redirect_to [:admin, @course_star], notice: '更新成功' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @course_star.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /admin/course_stars/1
  # DELETE /admin/course_stars/1.json
  def destroy
    if @course_star.destroy
      @result=[true, '删除成功', @course_star.id]
    else
      @result = [false, '删除失败']
    end
    respond_to do |format|
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course_star
    @course_star = CourseStar.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_star_params
    params.require(:course_star).permit(:course_id, :name, :stars)
  end
end