class Role < ActiveRecord::Base
  belongs_to :project, inverse_of: :roles

  has_many :memberships, inverse_of: :role
  has_many :users, through: :memberships
end
