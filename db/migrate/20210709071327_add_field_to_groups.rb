class AddFieldToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :conversation_id, :string
  end
end
