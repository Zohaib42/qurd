class UpdateMemberInteractor
  include Interactor

  delegate :member_attributes, :member, to: :context

  def call
    if member_attributes.present? && !member.update(member_attributes)
      context.fail!(errors: member.errors, meta: { error_message: member.errors.full_messages.to_sentence })
    end
  end
end
