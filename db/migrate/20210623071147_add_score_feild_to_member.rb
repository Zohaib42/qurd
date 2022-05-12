class AddScoreFeildToMember < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :score, :decimal
  end
end
