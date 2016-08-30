class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :soundcloud_username

      t.timestamps
    end
  end
end
