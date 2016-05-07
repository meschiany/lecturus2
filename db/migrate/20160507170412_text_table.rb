class TextTable < ActiveRecord::Migration
	def change
	  	create_table :texts do |t|
		  	t.integer :video_id
		  	t.integer :second
		  	t.integer :user_id
		  	t.boolean :active
		  	t.string  :description
		  	t.text :content
		  	
			t.timestamps
		end
  	end
end