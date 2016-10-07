class User
  module Likeable
    extend ActiveSupport::Concern

    # 赞
    def like(likeable)
      return false if likeable.blank? || liked?(likeable)
      likeable.transaction do
        likeable.liked_user_ids.push(id)
        likeable.likes_count += 1
        likeable.save
      end
    end

    # 取消赞
    def unlike(likeable)
      return false if likeable.blank?
      return false unless liked?(likeable)
      likeable.transaction do
        likeable.liked_user_ids.delete(id)
        likeable.likes_count -= 1
        likeable.save
      end
    end

    # 是否赞过
    def liked?(likeable)
      likeable.liked_by_user?(self)
    end
  end
end
