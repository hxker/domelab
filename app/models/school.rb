class School < ApplicationRecord
  has_many :users
  has_many :user_roles
  belongs_to :district
  validates :name, presence: true, uniqueness: true
  validates :district_id, presence: true
  after_validation :create_school_uuid, on: :create

  private

  def create_school_uuid
    self.school_uuid = SecureRandom.uuid.gsub('-', '')
  end
end
