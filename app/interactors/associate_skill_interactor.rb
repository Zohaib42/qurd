class AssociateSkillInteractor
  include Interactor

  delegate :skills, :interests, :member, to: :context

  def call
    skill_ids = Skill.where(name: skills).pluck(:id)
    interest_ids = Skill.where(name: interests).pluck(:id)

    member.skill_ids = skill_ids
    member.interest_ids = interest_ids

    return if member.save

    context.fail!(errors: member.errors, meta: { error_message: member.errors.full_messages.to_sentence })
  end
end
