class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :termine
      t.string :tabella

      t.timestamps
    end
  end
end
