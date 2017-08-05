class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.integer :vecchioid
      t.string :titolo
      t.decimal :prezzoeurodec
      t.string :edizione
      t.string :isbn
      t.integer :copie
      t.boolean :deposito
      t.integer :publisher_id
      t.integer :idtipoopera
      t.integer :annoedizione
      t.string :note
      t.integer :idaliquotaiva
      t.string :url2
      t.integer :annomodifica

      t.timestamps
    end
  end
end
