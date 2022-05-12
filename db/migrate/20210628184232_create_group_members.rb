class CreateGroupMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_members do |t|
      t.references :member
      t.references :group

      t.timestamps
    end
  end
end
