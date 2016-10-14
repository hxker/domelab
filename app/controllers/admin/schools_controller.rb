class Admin::SchoolsController < AdminController
  before_action :set_school, only: [:edit, :update]

  # GET /admin/schools
  # GET /admin/schools.json
  def index
    field = params[:field]
    keyword = params[:keyword]
    schools = School.left_joins(:district)
    if field.present? && keyword.present?
      if field =='district_id'
        schools = schools.where('districts.name like ?', "%#{keyword}%")
      else
        schools = schools.where(["schools.#{field} like ?", "%#{keyword}%"])
      end
    end
    @schools = schools.select('schools.*', 'districts.name as district_name').page(params[:page]).per(params[:per])

  end

  # GET /admin/schools/1
  # GET /admin/schools/1.json
  def show
    @school = School.left_joins(:district).where(id: params[:id]).select('schools.*', 'districts.name as district_name').take!
  end

  # GET /admin/schools/new
  def new
    @school = School.new
  end

  # GET /admin/schools/1/edit
  def edit
  end

  # POST /admin/schools
  # POST /admin/schools.json
  def create
    @school = School.new(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to [:admin, @school], notice: '学校创建成功!' }
        format.json { render action: 'show', status: :created, location: @school }
      else
        format.html { render action: 'new' }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/schools/1
  # PATCH/PUT /admin/schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to [:admin, @school], notice: '学校更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/schools/1
  # DELETE /admin/schools/1.json
  def destroy
    school_id = params[:id]
    has_use = UserRole.where(school_id: school_id).exists? || User.where(school_id: school_id).exists?
    if has_use
      @notice = [false, 0, '该学校已经被使用，不能删除']
    else
      school = School.find(school_id)
      school.destroy
      @notice = [true, school.id, '学校删除成功']
    end

    respond_to do |format|
      format.html { redirect_to admin_schools_url, notice: '学校删除成功!' }
      format.json { head :no_content }
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def school_params
    params.require(:school).permit!
  end
end