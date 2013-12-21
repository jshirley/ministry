class Milestone < ActiveRecord::Base
  belongs_to :project, inverse_of: :milestones
  belongs_to :user, inverse_of: :milestones

  validates :project, presence: true
  validates :user, presence: true

  validates_date :date

  default_scope { order("date ASC") }

  scope :past,   -> { where("date <= now()") }
  scope :future, -> { where("date > now()") }
end
