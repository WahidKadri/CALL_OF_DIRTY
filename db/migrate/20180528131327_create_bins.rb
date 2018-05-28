class CreateBins < ActiveRecord::Migration[5.2]
  def change
    create_table :bins do |t|
      t.string :color

      t.timestamps
    end
  end
end
