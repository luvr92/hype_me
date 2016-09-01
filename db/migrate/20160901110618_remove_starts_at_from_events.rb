class RemoveStartsAtFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :starts_at, :datetime
  end
end
