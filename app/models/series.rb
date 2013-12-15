class Series < ActiveRecord::Base
  belongs_to :user, inverse_of: :series

  has_many :series_projects, inverse_of: :series
  has_many :projects, through: :series_projects

  validates_date :start_date
  validates_date :end_date, after: :start_date
end
