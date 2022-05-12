class CreateBlockMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :block_members do |t|
      t.references :blocker
      t.references :member

      t.timestamps
    end
  end
end
