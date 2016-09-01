class RemoveEndsAtFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :ends_at, :datetime
  end
end
