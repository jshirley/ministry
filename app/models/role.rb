class Role < ActiveRecord::Base
  belongs_to :project, inverse_of: :roles

  has_many :memberships, inverse_of: :role
  has_many :users, through: :memberships

  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
