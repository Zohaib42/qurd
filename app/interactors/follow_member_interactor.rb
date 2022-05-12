class FollowMemberInteractor
  include Interactor

  delegate :current_member, :followed_id, to: :context

  before :validate_member_to_follow

  def call
    relation = current_member.active_relationships.find_or_initialize_by(followed_id: followed_id)
    return if relation.save

    context.fail!(errors: relation.errors, meta: { error_message: relation.errors.full_messages.to_sentence })
  end

  private

  def validate_member_to_follow
    if current_member.id == followed_id.to_i
      context.fail!(meta: { error_message: 'Sorry! You cannot follow yourself.' })
      return
    end

    context.fail!(meta: { error_message: 'Member does not exist.' }) unless Member.exists?(followed_id)
  end
end
