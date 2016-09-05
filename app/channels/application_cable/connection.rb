module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_guid

    def connect
      self.current_user_guid = find_verified_user
    end

    protected

    def find_verified_user
      cookies.signed[:user_id] || nil
    end

  end
end
