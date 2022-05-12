class AddColumnToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :add_to_portfolio, :boolean, default: false
  end
end
