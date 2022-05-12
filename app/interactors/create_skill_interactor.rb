class CreateSkillInteractor
  include Interactor

  delegate :skills, :interests, :member, to: :context

  before :validate_skill_format_and_size
  before :validate_interest_format_and_size

  def call
    context.fail!(errors: context.errors, meta: { error_message: context.errors.to_sentence }) if context.errors.present?

    create_skills(build_skills_array)
  end

  private

  def create_skills(skill_arrays)
    return if skill_arrays.blank?

    begin
      Skill.create!(skill_arrays)

      context.skills = skills
      context.interests = interests
    rescue ActiveRecord::RecordInvalid => e
      # TODO logger - raise exception email / rollbar error
      context.fail!(meta: { error_message: 'System is unable to create new skills, please try again latter!' })
    end
  end

  def existing_skills
    @existing_skills ||= Skill.pluck(:name)
  end

  def validate_skill_format_and_size
    context.errors = []

    return if skills.blank?

    skills
      .collect!(&:to_s)
      .collect!(&:strip)
      .collect!(&:titleize)

    context.errors << 'Skill name has invalid format' if !skills.all? { |skill| skill.match?(Skill::NAME_REGEX) }
    context.errors << 'Skills cannot be more than 5' if skills.length > 5
  end

  def validate_interest_format_and_size
    return if interests.blank?

    interests
      .collect!(&:to_s)
      .collect!(&:strip)
      .collect!(&:titleize)

    context.errors << 'Interest name has invalid format' if !interests.all? { |skill| skill.match?(Skill::NAME_REGEX) }
    context.errors << 'Interests cannot be more than 5' if interests.length > 5
  end

  def build_skills_array
    new_user_skills = skills - existing_skills if skills.present?
    new_user_interests = interests - existing_skills if interests.present?
    new_skills = new_user_skills.to_a + new_user_interests.to_a

    new_skills.uniq.collect { |skill_name| { name: skill_name, author_id: member.id } }
  end
end
