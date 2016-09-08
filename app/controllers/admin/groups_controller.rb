class Admin::GroupsController <AdminController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
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
    @groups = groups.select('groups.*', 'users.nickname', 'users.fullname').page(params[:page]).per(params[:per])
  end

  # GET /admin/groups/1
  # GET /admin/groups/1.json
  def show
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