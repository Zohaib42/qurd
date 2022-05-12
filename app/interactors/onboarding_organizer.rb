class OnboardingOrganizer
  include Interactor::Organizer

  organize UpdateMemberInteractor, CreateSkillInteractor, AssociateSkillInteractor
end

