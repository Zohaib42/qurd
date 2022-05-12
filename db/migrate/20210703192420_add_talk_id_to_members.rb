class AddTalkIdToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :talk_id, :string

    add_index :members, :talk_id
  end
end
