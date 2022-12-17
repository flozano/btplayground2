class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
