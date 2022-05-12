class GroupMember < ApplicationRecord
  belongs_to :member
  belongs_to :group

  def self.direct_chat_of(member_id, creator)
    where(member_id: member_id, group_id: creator.created_groups.direct.ids).first
  end
end
