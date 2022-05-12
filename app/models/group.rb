class Group < ApplicationRecord
  CHAT_TYPES = {
    channel: 'channel',
    direct: 'direct'
  }.freeze

  after_commit :sync_talkjs, on: %i[create update]

  enum chat_type: CHAT_TYPES

  validates :name, :chat_type, presence: true

  has_one_attached :image

  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members, after_add: :join_talkjs_conversation, after_remove: :leave_talkjs_conversation

  belongs_to :creator, class_name: 'Member'

  def last_message_time
    last_message_at.presence || created_at
  end

  private

  def sync_talkjs
    UpsertTalkjsGroupJob.perform_later(self) unless Rails.env.test?
  end

  def join_talkjs_conversation(member)
    ManageTalkjsParticipantsJob.perform_later(self, member, 'join') if persisted? && !Rails.env.test?
  end

  def leave_talkjs_conversation(member)
    ManageTalkjsParticipantsJob.perform_later(self, member, 'leave') if persisted? && !Rails.env.test?
  end
end
