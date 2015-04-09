class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :journal, :required => true
      t.string :term
      t.integer :retmax
      t.string :mindate
      t.string :maxdate

      t.timestamps null: false
    end
  end
end
