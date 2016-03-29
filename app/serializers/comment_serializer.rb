class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :version

  belongs_to :post

  def version
    '0.10.0'
  end
end
