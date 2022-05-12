class Member < ApplicationRecord
  USERNAME_FORMAT = /\A^[A-Za-z0-9_]{1,15}$\Z/i.freeze
  WEBSITE_URL_FORMAT = /((http|https|www.):\/\/)|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix.freeze
  STAR_SIGNS = %W[None Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn Aquarius Pisces]
  paginates_per 50
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  has_paper_trail
  has_person_name

  before_create :downcase_email

  validates :name, presence: true
  validates :pronouns, length: { maximum: 20 }, allow_blank: true
  validates :username, uniqueness: { case_sensitive: false }, format: { with: USERNAME_FORMAT }, allow_blank: true
  validates :mobile, phone: { possible: true, allow_blank: true, types: %i[mobile] }
  validates :email, email: true, uniqueness: { case_sensitive: false }
  validates :star_sign, inclusion: { in: STAR_SIGNS }, allow_blank: true
  validate :ensure_whitlisted_domain
  validate :ensure_valid_url

  has_one_attached :image

  has_many :notifications, foreign_key: 'recipient_id'
  has_many :notifiers, foreign_key: 'notifier_id'
  has_many :rsvps
  has_many :events, through: :rsvps
  has_many :shares
  has_many :likes
  has_many :group_members
  has_many :groups, through: :group_members
  has_many :created_groups, class_name: 'Group' ,foreign_key: 'creator_id'
  has_many :posts, foreign_key: 'creator_id', dependent: :destroy
  has_many :member_skills, dependent: :destroy
  has_many :skills, through: :member_skills,
                    after_add: :reset_skill_creatives_count,
                    after_remove: :reset_skill_creatives_count

  has_many :member_interests
  has_many :interests, through: :member_interests, source: :skill
  has_many :active_relationships,  class_name: 'Relationship',
                                   foreign_key: 'follower_id',
                                   dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships
  has_many :following, through: :active_relationships, source: :followed
  has_many :comments, inverse_of: :author, foreign_key: 'author_id'
  has_many :post_reports, foreign_key: 'reporter_id'
  has_many :reporting_posts, through: :post_reports, source: :post
  has_many :shares
  has_many :devices
  after_commit :sync_talkjs, on: %i[create update]
  has_many :reported_reports, foreign_key: 'reported_id', class_name: 'MemberReport', dependent: :destroy
  has_many :member_reports, foreign_key: 'reporter_id'
  has_many :reported_members, through: :member_reports, source: :reported
  has_many :reporting_members, through: :reports, source: :reporter
  has_many :block_members, foreign_key: 'blocker_id' # whom we block (middle table)
  has_many :blocking, class_name: 'BlockMember' # whom block us (middle table)
  has_many :blocked_members, through: :block_members, source: :member # members whom we block
  has_many :blocking_members, through: :blocking, source: :blocker # members whom block us
  has_many :comment_tags

  def reset_skill_creatives_count(skill)
    skill.refresh_creative_count
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, ENV['SECRET_KEY_BASE'])
  end

  def reset_password!
    raw, hashed = ::Devise.token_generator.generate(Member, :reset_password_token)
    self.update(reset_password_token: hashed, reset_password_sent_at: Time.zone.now)

    raw
  end

  def resend_confirmation_notification
    if can_send_confirmation? && send_confirmation_instructions
      self.update(confirmation_sent_at: Time.zone.now)
    end
  end

  def can_send_confirmation?
    confirmation_sent_at <= 10.minutes.ago
  end

  def email_domain
    email.to_s.split('@')[1]
  end

  def university
    CollegeDomain.domain_mapping[email_domain]
  end

  def avatar_url
    image.url if image.attached?
  end

  def following_user?(id)
    following_ids.include?(id)
  end

  def talk_signature
    return if talk_id.blank?

    OpenSSL::HMAC.hexdigest('sha256', ENV['TALK_JS_SECRET_KEY'], talk_id)
  end

  def device_tokens
    devices.pluck :token
  end

  def blocked_members_ids
    ids = blocked_member_ids + blocking_member_ids
    ids.uniq
  end

  def direct_chat_with(member_id)
    chat = GroupMember.direct_chat_of(member_id, self)
    return if chat.blank? || member_id == id

    chat.group.id
  end

  def website_url
    stripped_url = self[:website_url].strip
    url = URI.parse(stripped_url)

    return "https://#{stripped_url}" if url.scheme.blank? && stripped_url.present?

    stripped_url
  rescue StandardError => _e
    self[:website_url]
  end

  private

  def ensure_whitlisted_domain
    return if CollegeDomain.exists?(domain: email_domain)

    errors.add(:email, 'is not whitelisted')
  end

  def ensure_valid_url
    return if website_url.nil?

    valid_url = website_url =~ WEBSITE_URL_FORMAT
    return if valid_url == 0

    errors.add(:website_url, 'is not valid URL')
  end

  def sync_talkjs
    UpsertTalkjsMemberJob.perform_later(self) unless Rails.env.test?
  end

  def downcase_email
    self.email.downcase!
  end
end
