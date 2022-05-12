class AddPronounsToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :pronouns, :string, limit: 20
  end
end
