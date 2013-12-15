class FieldValue < ActiveRecord::Base
  belongs_to :project
  belongs_to :field
  belongs_to :user
end
