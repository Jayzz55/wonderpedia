class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :body
      t.boolean :private, default: false

      t.timestamps
    end

    add_index :wikis, :id, unique: true

  end
end
