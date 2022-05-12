class AddScoreFeildToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :score, :decimal
  end
end
