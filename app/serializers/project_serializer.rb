class ProjectSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, tags: :tags
  has_many :users, :roles, :field_values

  def tags
    object.tag_list
  end
end
