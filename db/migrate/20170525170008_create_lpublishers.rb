class CreateLpublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :lpublishers do |t|
      t.integer :ID_EDITORE
      t.string :Nome

      t.timestamps
    end
  end
end
