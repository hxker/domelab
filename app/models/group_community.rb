class GroupCommunity < ApplicationRecord
  include Likeable
  belongs_to :group
  belongs_to :user
  has_many :child_group_communities, class_name: GroupCommunity, foreign_key: :parent_id
  belongs_to :father_group_community, class_name: GroupCommunity, foreign_key: :parent_id

  validates :user_id, :group_id, :content, presence: true
end
