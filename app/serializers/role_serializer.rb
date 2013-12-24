class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :filled_count, :needed_count, :quantity
  has_many :users

  def needed_count
    return object.quantity - object.filled_count
  end
end
