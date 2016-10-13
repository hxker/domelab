class Admin::NewsController < AdminController
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  before_action do
    authenticate_permissions(['admin'])
  end

  # GET /admin/news
  # GET /admin/news.json
  def index
    field = params[:field]
    keyword = params[:keyword]
    news = News.left_joins(:admin).select(:id, :name, :content, :status, :is_hot, :news_type, :created_at, :updated_at, "admins.name as admin_name")
    if field.present? && keyword.present?
      if field == 'publisher'
        news = news.where(["admins.name like ?", "%#{keyword}%"])
      else
        news = news.where(["news.#{field} like ?", "%#{keyword}%"])
      end
    end
    @news = news.page(params[:page]).per(params[:per])
    @news_array = @news.map { |n| {
        id: n.id,
        name: n.name,
        content: n.content,
        status: n.status,
        is_hot: n.is_hot,
        publisher: n.admin_name,
        type: n.news_type,
        created_at: n.created_at,
        updated_at: n.updated_at
    } }
  end

  # GET /admin/news/1
  # GET /admin/news/1.json
  def show
  end

  # GET /admin/news/new
  def new
    @new = News.new
  end

  # GET /admin/news/1/edit
  def edit
  end

  # POST /admin/news
  # POST /admin/news.json
  def create
    @new = News.new(news_params)

    respond_to do |format|
      if @new.save
        format.html { redirect_to [:admin, @new], notice: '新闻创建成功' }
        format.json { render action: 'show', status: :created, location: @new }
      else
        format.html { render action: 'new' }
        format.json { render json: @new.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/news/1
  # PATCH/PUT /admin/news/1.json
  def update
    respond_to do |format|
      if @new.update(news_params)
        format.html { redirect_to [:admin, @new], notice: '新闻更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @new.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /admin/news/1
  # DELETE /admin/news/1.json
  def destroy
    @new.destroy
    respond_to do |format|
      format.html { redirect_to admin_news_index_url, notice: '新闻删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_news
    @new = News.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:name, :news_type, :content, :cover, {images: []}, :desc, :status, :is_hot, :admin_id)

  end
end
