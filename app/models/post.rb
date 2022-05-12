class Post < ApplicationRecord
  POST_TYPES = {
    video: 'video',
    image: 'image',
    text: 'text',
    audio: 'audio'
  }.freeze

  SHARE_TYPES = {
    attachment: 'attachment',
    link: 'link'
  }.freeze

  PAGE_SIZE = 10
  IMAGE_TYPES = %w(image/jpg image/jpeg image/gif image/png)
  AUDIO_TYPES = %w(audio/mp3 audio/x-wav audio/wav audio/wma audio/ogg audio/mpeg audio/x-mpeg audio/x-mp3 audio/mpeg3 audio/x-mpeg3 audio/mpg audio/x-mpg audio/x-mpegaudio)
  VIDEO_TYPES = %w(video/mp4 video/webm video/quicktime video/x-ms-wmv)
  MAX_ATTACHMENT_SIZE = 250.megabytes
  MAX_DESCRIPTION_CHARS = 25_000

  validates :share_type, presence: true, if: -> { !text? }

  validates :title, :post_type, presence: true
  validates :description, length: { maximum: MAX_DESCRIPTION_CHARS }, allow_blank: true

  validates :link, presence: true, if: -> { link? }
  validates :attachment, presence: true, if: -> { attachment? }

  validate :correct_file_content_type
  validate :ensure_attachment_size

  enum post_type: POST_TYPES
  enum share_type: SHARE_TYPES

  has_one_attached :attachment
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :post_reports, dependent: :destroy
  has_many :reporters, class_name: 'Member', through: :post_reports
  belongs_to :creator, class_name: 'Member'

  def liked_by?(member_id)
    likes.any? { |like| like.member_id == member_id }
  end

  def shared_by?(member_id)
    shares.any? { |share| share.member_id == member_id }
  end

  def self.hottest_posts(type = nil, current_member)
    scope = where("creator_id NOT IN (?)", current_member.blocked_members_ids + [0])
    scope = scope.where("post_type = ?", type) if type.present?
    scope.order(score: :desc).includes(
      :creator,
      :shares,
      :attachment_attachment,
      comments: :author,
      likes: :member
    ).limit(15)
  end

  def link
    stripped_url = self[:link].strip
    url = URI.parse(stripped_url)

    return "https://#{stripped_url}" if url.scheme.blank? && stripped_url.present?

    stripped_url
  rescue StandardError => _e
    self[:link]
  end

  private

  def correct_file_content_type
    return if should_not_validate_attachment?

    if image? && !attachment.content_type.in?(IMAGE_TYPES)
      errors.add(:attachment, 'Must be an Image.')
    elsif video? && !attachment.content_type.in?(VIDEO_TYPES)
      errors.add(:attachment, ': This Video format is not supported.')
    elsif audio? && !attachment.content_type.in?(AUDIO_TYPES)
      errors.add(:attachment, 'Must be an Audio file.')
    end
  end

  def ensure_attachment_size
    return if should_not_validate_attachment?

    errors.add(:attachment, 'should not be larger than 250 Mb.') if attachment.byte_size > MAX_ATTACHMENT_SIZE
  end

  def should_not_validate_attachment?
    text? || link? || attachment.blank?
  end
end
