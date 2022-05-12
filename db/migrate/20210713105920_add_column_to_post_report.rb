class AddColumnToPostReport < ActiveRecord::Migration[6.1]
  def change
    add_column :post_reports, :status, :string, default: 'open'
  end
end
