class AddFieldsToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :link, :text
    add_column :posts, :share_type, :string
  end
end
