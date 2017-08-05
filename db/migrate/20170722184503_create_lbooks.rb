class CreateLbooks < ActiveRecord::Migration[5.0]
  def change
    create_table :lbooks do |t|
      t.integer :c01_vecchioid
      t.string :c02_titolo
      t.string :c03_prezzoeurodec
      t.string :c04_EDIZIONE
      t.integer :c05_IDDISTRIBUTORE
      t.integer :c06_IDSERIE
      t.string :c07_ISBN
      t.integer :c08_copie
      t.boolean :c09_deposito
      t.integer :c10_publisher_id
      t.integer :c11_IDTIPOOPERA
      t.integer :c12_ANNOEDIZIONE
      t.string :c13_note
      t.integer :c14_idaliquotaiva
      t.string :c15_url2

      t.timestamps
    end
  end
end
