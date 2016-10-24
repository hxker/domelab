class Admin::PhotosController < AdminController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /admin/demeanor
  # GET /admin/demeanor.json
  def index
    type = params[:type]
    type_id = params[:td]
    if type.present? && type_id.present?
      case type
        when '1' then
          @model_type = Lesson.joins(:course).where(id: type_id).select(:name, 'courses.name as course_name').take!
        else
          render_optional_error(404)
      end
      @photos = Photo.where(type_id: type_id).page(params[:page]).per(params[:per])
    else
      render_optional_error(404)
    end
  end

  # GET /admin/demeanor/1
  # GET /admin/demeanor/1.json
  def show
  end

  # GET /admin/demeanor/new
  def new
    @photo = Photo.new
  end

  # GET /admin/demeanor/1/edit
  def edit
  end

  # POST /admin/demeanor
  # POST /admin/demeanor.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save

        format.html { redirect_to "/admin/photos", notice: '上传成功' }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  # PATCH/PUT /admin/demeanor/1
  # PATCH/PUT /admin/demeanor/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to "#{admin_photo_url(@photo)}", notice: '更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/demeanor/1
  # DELETE /admin/demeanor/1.json
  def destroy
    if @photo.destroy
      @result = {status: true, message: '删除成功', photo_id: @photo.id}
    else
      @result = {status: false, message: '删除失败'}
    end
    respond_to do |format|
      format.html { redirect_to "#{admin_photos_url}?td=#{@photo.type_id}&type=#{@photo.photo_type}", notice: '删除成功' }
      format.json { head :no_content }
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def photo_params
    params.require(:photo).permit(:type_id, :image, :photo_type, :sort, :status)
  end

end