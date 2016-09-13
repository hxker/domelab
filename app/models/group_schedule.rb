class GroupSchedule < ApplicationRecord
  belongs_to :group
  validates :group_id, :title, :start, presence: true
end
