class AddUrilFieldToMember < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :website_url, :string
  end
end
