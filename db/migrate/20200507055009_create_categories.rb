class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
    	t.integer :user, null: false, foreign_key: true
        t.string :name, null: false

      t.timestamps
    end
  end
end
