class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :version

  has_one :post, embed: :ids, include: true

  def version
    '0.10.0'
  end
end
