class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: { minimum: 3}, uniqueness: true
  has_many :reviews do
  def build_with_user(attributes = {}, user)
    attributes[:user] ||= user
    build(attributes)
  end
end

end
