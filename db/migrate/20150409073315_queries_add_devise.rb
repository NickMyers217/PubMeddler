class QueriesAddDevise < ActiveRecord::Migration
  def change
  	change_table :queries do |t|
  		t.string :title
  		t.integer :user_id
  	end
  end
end
