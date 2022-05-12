class AddStarSignToMember < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :star_sign, :string
  end
end
