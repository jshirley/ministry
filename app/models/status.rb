class Status < ActiveRecord::Base
  has_many :projects, inverse_of: :status

  def self.initial_status
    self.find_or_create_by(name: "Pending") do |status|
      status.description = "The initial status, just setting up and defining the project."
    end
  end
end
