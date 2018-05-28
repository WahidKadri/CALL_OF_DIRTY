class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :bar_code
      t.text :description
      t.string :photo

      t.timestamps
    end
  end
end
