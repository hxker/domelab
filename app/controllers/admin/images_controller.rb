class Admin::ImagesController < AdminController
  before_action :set_news


  def new

  end

  def edit

  end

  def create
    add_more_images(images_params[:images])
    flash[:error] = '上传失败' unless @news.save
    redirect_back(fallback_location: '/admin/news')
  end


  def update_image
    update_images_at_index(params[:news][:index].to_i, params[:news][:sss])
    redirect_back(fallback_location: '/admin/news')
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = '删除失败' unless @news.save
    if @news.save
      @result = [true, '删除成功', params[:id]]
    else
      @result = [false, '删除失败']
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: '/admin/news') }
      format.json
      format.js
    end
  end


  private

  def set_news
    @news = News.find(params[:news_id])
  end

  def add_more_images(new_images)
    images = @news.images
    images += new_images
    @news.images = images
  end

  def update_images_at_index(index, new_images)
    remain_images = @news.images
    if remain_images.length == 1
      @news.remove_images!
    else
      deleted_image = remain_images.delete_at(index)
      deleted_image.try(:remove!)
      remain_images.insert(index, new_images)
      @news.images = remain_images
    end


  end

  def remove_image_at_index(index)
    remain_images = @news.images
    if remain_images.length == 1
      @news.remove_images!
    else
      deleted_image = remain_images.delete_at(index)
      deleted_image.try(:remove!)
      @news.images = remain_images
    end
  end

  def images_params
    params.require(:news).permit({images: []})
  end
end