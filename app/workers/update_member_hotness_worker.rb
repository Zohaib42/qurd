# frozen_string_literal: true

class UpdateMemberHotnessWorker
  include Sidekiq::Worker
  
  def perform
    Member.includes(:posts).find_each do |member|
      UpdateMemberHotnessService.new(member).update_score
    end
  end
end
