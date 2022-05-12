class WebhooksController < ApplicationController
  def talkjs
    return unless valid_talk_webhook?

    group.update(group_params)
    send_group_message_notifications if sender.present?

    head :ok
  end

  private

  def valid_talk_webhook?
    recieved_signature = request.headers['X-TalkJS-Signature']
    timestamp = request.headers['X-TalkJS-Timestamp']

    payload = "#{timestamp}.#{request.raw_post}"
    valid_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['TALK_JS_SECRET_KEY'], payload)

    valid_signature.upcase == recieved_signature
  end

  def group
    @group ||= Group.find_by!(conversation_id: params[:data][:conversation][:id])
  end

  def sender
    return if params[:data][:sender].blank?

    @sender ||= Member.find_by!(talk_id: params[:data][:sender][:id])
  end

  def message
    params[:data][:message]
  end

  def group_params
    { last_message: message[:text], last_message_at: Time.at(message[:createdAt].to_i / 1000) }
  end

  def send_group_message_notifications
    group.members.each do |member|
      NotificationManager.new(member, sender, group, NOTIFICATION_TYPES[:message], { message: message[:text] }).call
    end
  end
end
