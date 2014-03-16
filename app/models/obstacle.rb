class Obstacle < ActiveRecord::Base
  include RankedModel
  ranks :row_order, with: :project_id

  default_scope { where( active: true ).order(:row_order) }

  belongs_to :project, inverse_of: :obstacles, touch: true
  belongs_to :user, inverse_of: :obstacles

  validates :user, presence: true
  validates :project, presence: true
  validates :description, presence: true

  # Need to sort out flag
  validates :flag, inclusion: { in: [ 0, 1 ] }

  scope :unresolved, -> { where("obstacles.strategy IS NULL") }
  scope :resolved,   -> { where("obstacles.strategy IS NOT NULL") }
  scope :flagged,    -> { where("obstacles.flag > 0") }

  def flagged?
    flag > 0
  end

end
