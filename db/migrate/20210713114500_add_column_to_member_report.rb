class AddColumnToMemberReport < ActiveRecord::Migration[6.1]
  def change
    add_column :member_reports, :status, :string, default: 'open'
  end
end
