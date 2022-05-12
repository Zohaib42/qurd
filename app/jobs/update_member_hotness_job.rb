class UpdateMemberHotnessJob < ApplicationJob
  def perform
    Member.includes(:posts).find_each do |member|
      UpdateMemberHotnessService.new(member).update_score
    end
  end
end
