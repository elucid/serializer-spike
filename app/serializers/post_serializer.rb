class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :version

  has_one :author, embed: :ids, include: true

  has_many :comments, embed: :ids, include: true

  def version
    '0.10.0'
  end
end
