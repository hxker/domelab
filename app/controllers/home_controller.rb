class HomeController < ApplicationController
  def index
    courses = Course.where(status: 1)
    @dome_courses = courses.where(course_type: 0).limit(3)
    @expert_courses = courses.where(course_type: 1).limit(3)

  end

  def error_404
    render_optional_error(404)
  end
end
