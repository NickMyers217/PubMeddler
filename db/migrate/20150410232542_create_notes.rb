class CreateNotes < ActiveRecord::Migration
	def change
		create_table :notes do |t|
			t.integer :user_id, null: false
			t.string :pmid, 	null: false
			t.text :text, 		null: false

			t.timestamps null: false
		end
	end
end
