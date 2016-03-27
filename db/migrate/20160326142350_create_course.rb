class CreateCourse < ActiveRecord::Migration
	def change
	  	create_table :courses do |t|
		  	t.integer :college_id
		  	t.string :name
		  	t.string :professor
		  	t.integer :year
		  	t.integer :semester

			t.timestamps
		end
  	end
end
