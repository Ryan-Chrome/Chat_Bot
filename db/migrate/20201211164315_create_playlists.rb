class CreatePlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :playlists do |t|
      t.string :video_id
      t.string :title

      t.timestamps
    end
  end
end
