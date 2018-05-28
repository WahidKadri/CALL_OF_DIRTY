class CreatePackagings < ActiveRecord::Migration[5.2]
  def change
    create_table :packagings do |t|
      t.string :name
      t.references :bin, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
