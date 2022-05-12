class CreateCollegeDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :college_domains do |t|
      t.references :college, null: false, foreign_key: true
      t.string :domain

      t.timestamps
    end
  end
end
