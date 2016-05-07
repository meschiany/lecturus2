class AddToken < ActiveRecord::Migration
	change_table :users do |t|
	  t.string :token
	end
end
