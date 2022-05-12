class AddFieldsToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :last_message, :text
    add_column :groups, :last_message_at, :datetime
  end
end
