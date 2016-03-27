class CreateVideos < ActiveRecord::Migration
  	def change
	  	create_table :videos do |t|
		  	t.string :title
		  	t.integer :master_id
			t.datetime :start_record_timestamp
			t.datetime :end_record_timestamp
			t.integer :course_id
			t.decimal :length
			t.string :status

			t.timestamps
		end
  	end
end