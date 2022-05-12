class RetrievePostsService
  attr_accessor :offset, :current_member, :scope

  def initialize(offset, current_member)
    @offset = offset
    @current_member = current_member
  end

  def fetch_data
    following_ids = ([current_member.id] + current_member.following_ids) - current_member.blocked_members_ids
    @scope = Post.where('creator_id IN (?)', following_ids)

    result = offset.present? ? scope.where('id < ?', offset) : scope

    result =
      result
      .includes(:creator, comments: :author, likes: :member)
      .with_attached_attachment
      .limit(Post::PAGE_SIZE).order(created_at: :desc)

    shares =
      Share
      .where(post_id: result.collect(&:id), member_id: following_ids)
      .includes(:member, post: [:creator, { comments: :author }, { likes: :member }])

    [meta(result), result, shares]
  end

  private

  def meta(collection)
    {
      total_count: collection.count,
      can_scroll: can_scroll?(collection),
      offset: collection.last&.id
    }
  end

  def can_scroll?(collection)
    return false if scope.blank? || collection.blank?

    collection.last.id != scope.last.id
  end
end
