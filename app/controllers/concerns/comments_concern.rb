require 'serializers/comment_serializer'

module CommentsConcern

  extend ActiveSupport::Concern

  @@keys = [:id, :content, :user, :created_at, :updated_at]

  def create_comment(user: nil, data: {})
    return false unless user or !data.blank?

    comment = initialize_comment

    comment[:id] = @uuid
    comment[:content] = data[:content]
    comment[:user] = user

    serialize comment
  end

  def update_comment(comment: nil, data: {})
    return false unless comment or !data.blank?
    comment["content"] = data[:content]
    hash[:updated_at] = Time.new
    comment
  end

  private

  def initialize_comment
    @uuid = SecureRandom.hex.to_sym
    hash = Hash.new
    hash[:created_at] = Time.new
    hash[:updated_at] = hash[:created_at]
    hash
  end

  def serialize(comment = {})
    @@keys.inject({}) do |serialized, k|
      serialized[k] = comment[k] if comment.has_key?(k)
      serialized
    end
  end
end
