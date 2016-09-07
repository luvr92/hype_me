class AddEventUrlToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :event_url, :string
  end
end
