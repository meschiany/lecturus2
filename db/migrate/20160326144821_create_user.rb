class CreateUser < ActiveRecord::Migration
	def change
	  	create_table :users do |t|
		  	t.string :email
			t.string :f_name
			t.string :l_name
			t.integer :college_id
			t.string :password

			t.datetime :last_login_timestamp
			t.timestamps
		end
  	end
end
