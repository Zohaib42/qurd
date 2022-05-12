# frozen_string_literal: true

class PushNotificationJob < ApplicationJob
  queue_as :notifications

  def perform
    Rpush.push
  end
end
