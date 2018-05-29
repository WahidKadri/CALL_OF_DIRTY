class AddMaterialToPackaging < ActiveRecord::Migration[5.2]
  def change
    add_column :packagings, :material, :string
  end
end
