class AddMemberToSkills < ActiveRecord::Migration[6.1]
  def change
    add_reference :skills, :author
  end
end
