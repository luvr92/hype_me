class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.text :title
      t.references :club, foreign_key: true
      t.string :price
      t.string :address
      t.time :starts_at
      t.time :ends_at
      t.text :description

      t.timestamps
    end
  end
end
