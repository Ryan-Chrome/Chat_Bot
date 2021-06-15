class CreateCounters < ActiveRecord::Migration[6.0]
  def change
    create_table :counters do |t|
      t.string :name, null: false
      t.datetime :start_time, null: false
      t.datetime :stop_time

      t.timestamps
    end
  end
end
