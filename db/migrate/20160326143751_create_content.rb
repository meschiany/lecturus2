class CreateContent < ActiveRecord::Migration
	def change
	  	create_table :contents do |t|
		  	t.integer :video_id
		  	t.integer :second
		  	t.integer :user_id
		  	t.integer :type
		  	t.boolean :active
		  	t.text :text
		  	t.string :f_type
		  	t.string :f_name

			t.timestamps
		end
  	end
end



