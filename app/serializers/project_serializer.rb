class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :tags

  def tags
    [ "fuck", "you" ]
  end
end
