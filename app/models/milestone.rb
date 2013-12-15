class Milestone < ActiveRecord::Base
  belongs_to :project, inverse_of: :milestones
  belongs_to :user, inverse_of: :milestones

  validates :project, presence: true
  validates :user, presence: true

  validates_date :date
end
