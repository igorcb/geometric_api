class CreateCircles < ActiveRecord::Migration[7.1]
  def change
    create_table :circles do |t|
      t.references :frame, null: false, foreign_key: true
      t.decimal :center_x, precision: 10, scale: 2, null: false
      t.decimal :center_y, precision: 10, scale: 2, null: false
      t.decimal :diameter, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end
