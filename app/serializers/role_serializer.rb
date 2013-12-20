class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :filled_count, :quantity
  has_many :users
end
