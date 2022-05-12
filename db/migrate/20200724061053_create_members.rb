class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.string :email
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.string :mobile
      t.string :verification_code
      t.boolean :verified
      t.datetime :deleted_at, index: true
      t.boolean :disabled, index: true

      t.timestamps
    end
  end
end
