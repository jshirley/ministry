class SeriesProject < ActiveRecord::Base
  include RankedModel
  ranks :row_order

  belongs_to :series, inverse_of: :series_project
  belongs_to :project, inverse_of: :series_project

  validates :series, presence: true
  validates :project, presence: true
end
