module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :authenticate!

      # 获取区县
      # GET /api/v1/users/get_districts

      def get_districts
        render json: District.select(:id, :name, :city)
      end

      # 获取学校
      # GET /api/v1/users/get_schools

      def get_schools
        requires! :district_id
        schools = School.where(status: 1, district_id: params[:district_id]).select(:id, :name, :teacher_role)
        render json: schools
      end

    end
  end
end
