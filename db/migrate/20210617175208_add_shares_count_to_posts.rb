class AddSharesCountToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :shares_count, :integer, default: 0
  end
end
