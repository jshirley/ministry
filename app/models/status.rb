class Status < ActiveRecord::Base
  has_many :projects, inverse_of: :status
end
