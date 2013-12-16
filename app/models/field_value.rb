class FieldValue < ActiveRecord::Base
  belongs_to :project, inverse_of: :field_values, touch: true
  belongs_to :field, inverse_of: :field_values

  belongs_to :user

  validates :project, presence: true
  validates :field, presence: true
end
