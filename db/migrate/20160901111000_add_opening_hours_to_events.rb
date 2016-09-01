class AddOpeningHoursToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :opening_hours, :string
  end
end
