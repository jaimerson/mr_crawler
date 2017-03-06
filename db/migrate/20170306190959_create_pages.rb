class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.string :url

      t.timestamps null: false
    end
    add_index :pages, :title
  end
end
