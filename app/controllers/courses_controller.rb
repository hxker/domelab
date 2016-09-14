class CoursesController < ApplicationController
  before_action :authenticate_user!

  def index
    @courses = Course.where(course_type: 1, status: 1).select(:id, :name)
  end

  def dome
    @groups = Group.where(status: 1).select(:id, :name)
  end

  def apply_group

  end
end