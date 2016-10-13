class NewsController < ApplicationController
  def index
    @news = News.where(status: true)
  end

  def show
    @news = News.find(params[:id])
  end
end
