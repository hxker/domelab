class LikesController < ApplicationController
  before_action :authenticate_user!, :set_likeable

  def create
    @result = current_user.like(@item)
    # respond_to do |format|
    #   format.js
    # end
    # render plain: @item.reload.likes_count
    render json: @result
  end

  def destroy
    @result = current_user.unlike(@item)
    # respond_to do |format|
    #   format.js
    # end
    # render plain: @item.reload.likes_count
    render json: @result
  end

  private

  def set_likeable
    @success = false
    @element_id = "likeable_#{params[:type]}_#{params[:id]}"
    unless params[:type].in?(%w(GroupCommunity GroupOpu))
      render plain: '-1'
      return false
    end

    case params[:type].downcase
      when 'groupcommunity'
        klass = GroupCommunity
      when 'groupopu'
        klass = GroupOpu
      else
        return false
    end

    @item = klass.find_by_id(params[:id])
    render plain: '-2' if @item.blank?
  end
end
