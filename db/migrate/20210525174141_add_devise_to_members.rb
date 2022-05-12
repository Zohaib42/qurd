# frozen_string_literal: true

class AddDeviseToMembers < ActiveRecord::Migration[6.1]
  def change
    change_table :members do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end

    add_column :members, :username, :string

    remove_column :members, :password_digest, :string
    remove_column :members, :verification_code, :string
    remove_column :members, :verified, :boolean
    remove_column :members, :deleted_at, :datetime
    remove_column :members, :disabled, :boolean

    add_index :members, :email, unique: true
    add_index :members, :reset_password_token, unique: true
    add_index :members, :confirmation_token,   unique: true
  end
end
