class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :version

  has_many :posts, embed: :ids, include: true

  def version
    '0.10.0'
  end
end
