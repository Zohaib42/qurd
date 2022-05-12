module UsersHelper
  def create_all_users
    let!(:admin_user) { create :admin }
    let!(:instructor_user) { create :instructor }
    let!(:student_user) { create :student }
  end
end

RSpec.configure do |config|
  config.extend UsersHelper
end
