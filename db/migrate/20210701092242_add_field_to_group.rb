class AddFieldToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :chat_type, :string
  end
end
