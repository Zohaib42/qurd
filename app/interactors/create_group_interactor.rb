class CreateGroupInteractor
  include Interactor

  delegate :current_member, :params, to: :context

  before do
    params[:member_ids].push(current_member.id)
  end

  def call
    group = find_or_create_group
    group.assign_attributes(params)

    context.group = group and return if group.save

    context.fail!(errors: group.errors, meta: { error_message: group.errors.full_messages.to_sentence })
  end

  private

  def direct_chat?
    params[:chat_type] == 'direct'
  end

  def find_or_create_group
    if direct_chat? && params[:member_ids]
      chat.blank? ? current_member.created_groups.build(params) : chat.group
    else
      current_member.created_groups.build(params)
    end
  end

  def chat
    @chat ||= GroupMember.direct_chat_of(params[:member_ids].first, current_member)
  end
end
