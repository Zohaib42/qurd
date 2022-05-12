class FollowMembersInteractor
  include Interactor

  delegate :current_member, :member_ids, to: :context

  def call
    member_ids.each do |member_id|
      current_member.active_relationships.find_or_initialize_by(followed_id: member_id)
    end

    return if current_member.save

    context.fail!(errors: current_member.errors, meta: { error_message: current_member.errors.full_messages.to_sentence })
  end
end
