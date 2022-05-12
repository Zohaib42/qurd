class UpdateGroupInteractor
  include Interactor

  delegate :group, :params, to: :context

  def call
    @existing_group_member_ids = group.member_ids

    context.fail!(errors: group.errors, meta: { error_message: group.errors.full_messages.to_sentence }) unless group.update(params)

    add_message(added_member_ids) if added_member_ids.present?
    remove_msg(removed_member_ids) if removed_member_ids.present?
  end

  private

  def added_member_ids
    group.reload.member_ids - @existing_group_member_ids
  end

  def removed_member_ids
    @existing_group_member_ids - group.reload.member_ids
  end

  def add_message(member_ids)
    TalkjsGroupMessageJob.perform_later(group, "#{usernames(member_ids)} has been added to the group")
  end

  def remove_msg(member_ids)
    TalkjsGroupMessageJob.perform_later(group, "#{usernames(member_ids)} has been removed from the group")
  end

  def usernames(member_ids)
    Member.where(id: member_ids).pluck(:username).to_sentence
  end
end
