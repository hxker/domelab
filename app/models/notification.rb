class Notification < ApplicationRecord
  belongs_to :user, foreign_key: :guid
  validates :user_id, :message_type, :content, presence: true

  scope :unread, -> { where(read: false) }
  after_create :realtime_push_to_client

  private

  def realtime_push_to_client
    if user
      hash = notify_hash
      hash[:count] = self.user.notifications.unread.count
      PushJob.perform_later hash
    end
  end

  def notify_hash
    {
        content: self.content[0, 30],
        user_id: self.user_id,
        time: Time.now.try(:strftime, '%Y-%m-%d %H:%M:%S')
    }
  end

end

