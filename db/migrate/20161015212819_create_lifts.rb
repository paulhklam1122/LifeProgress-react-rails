class CreateLifts < ActiveRecord::Migration[5.0]
  def change
    create_table :lifts do |t|
      t.date :date
      t.string :lift_name
      t.boolean :is_metric
      t.integer :weight_lifted
      t.integer :reps_performed
      t.integer :one_rep_max

      t.timestamps
    end
  end
end
