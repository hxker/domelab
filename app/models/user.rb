class User < ApplicationRecord
  alias_attribute :username, :guid
  devise :cas_authenticatable

  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :nickname
        self.nickname = value
      end
    end
  end
end
