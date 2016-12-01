class User < ApplicationRecord
  belongs_to :district, optional: true
  belongs_to :school, optional: true
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :notifications
  has_many :group_user_ships
  has_many :groups, through: :group_user_ships
  has_many :user_lesson_tests
  has_many :group_communities
  has_many :group_opus
  has_one :sign_in
  has_many :consults
  alias_attribute :username, :id
  attr_accessor :desc_family, :desc_certificate, :cover
  devise :cas_authenticatable

  validates :gender, inclusion: [1, 2], allow_blank: true
  validates :school_id, numericality: {only_integer: true}, allow_blank: true
  validates :grade, numericality: {only_integer: true}, allow_blank: true
  validates :bj, numericality: {only_integer: true}, allow_blank: true
  validates :district_id, numericality: {only_integer: true}, allow_blank: true
  validates :nickname, presence: true, uniqueness: true, length: {in: 2..20}, format: {with: /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/i, message: '昵称只能包含中文、数字、字母、下划线'}
  validates :student_code, allow_blank: true, uniqueness: true, length: {is: 19}, numericality: {only_integer: true}

  include Likeable

  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
        when :nickname
          self.nickname = value
        when :mobile
          self.mobile = value
        when :email
          self.email = value
        else
      end
    end
  end
end
