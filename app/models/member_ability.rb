class MemberAbility
  include CanCan::Ability

  def initialize(member)
    member ||= Member.new # guest member (not logged in)

    return unless member.confirmed?

    can %i[profile], :accounts
    can :read, Skill
    can %i[create], :onboardings
    can :manage, Member
    can %i[index create show], Post
    can :destroy, Post, creator_id: member.id
    can %i[index create], Comment
    can :destroy, Comment, author_id: member.id
    can :manage, Like
    can :create, Share
    can :destroy, Share, member_id: member.id
    can :index, :feeds
    can %i[index show], Event
    can :manage, Group
    can %i[create destroy], BlockMember
    can %i[create destroy], PostReport
    can %i[create destroy], MemberReport
    can %i[create show], Group
    can %i[create], Rsvp
    can %i[destroy], Rsvp, member_id: member.id
    can %i[destroy update], Group, creator_id: member.id
    can :create, Device
    can :index, Notification, member_id: member.id
    can :read, Notification
    can :index, College
  end
end
