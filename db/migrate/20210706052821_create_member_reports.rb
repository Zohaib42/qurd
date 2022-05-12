class CreateMemberReports < ActiveRecord::Migration[6.1]
  def change
    create_table :member_reports do |t|
      t.text :reason
      t.references :reporter
      t.references :reported

      t.timestamps
    end
  end
end
