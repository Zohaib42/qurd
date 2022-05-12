class LeaveGroupInteractor
  include Interactor

  delegate :params, :group, to: :context

  def call
    group.destroy and return if group.creator_id == params[:member_id].to_i

    group.update(member_ids: group.member_ids - [params[:member_id]])

    TalkjsGroupMessageJob.perform_later(group, "#{member.username} has left the group")
  end

  private

  def member
    @member ||= Member.find params[:member_id]
  end
end
