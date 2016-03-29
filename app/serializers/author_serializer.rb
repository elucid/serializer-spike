class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :version

  has_many :posts


  def version
    '0.10.0'
  end
end
