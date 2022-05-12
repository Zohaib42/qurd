module Api
  module V1
    class SkillsController < SecureController
      def index
        @skills = Skill.latest(column: :creatives)
      end
    end
  end
end
