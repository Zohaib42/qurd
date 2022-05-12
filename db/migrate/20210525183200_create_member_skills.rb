class CreateMemberSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :member_skills do |t|
      t.belongs_to :skill, null: false
      t.belongs_to :member, null: false

      t.timestamps
    end

    add_index :member_skills, [:skill_id, :member_id], unique: true
  end
end
