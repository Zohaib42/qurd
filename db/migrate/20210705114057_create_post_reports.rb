class CreatePostReports < ActiveRecord::Migration[6.1]
  def change
    create_table :post_reports do |t|
      t.text :reason
      t.references :post
      t.references :reporter

      t.timestamps
    end
  end
end
