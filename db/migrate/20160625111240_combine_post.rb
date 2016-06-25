class CombinePost < ActiveRecord::Migration
	def change
    	change_table :posts do |t|
    		t.string :content_type
      		t.rename :file_name, :content
			t.remove :description
			t.remove :file_type
			t.remove :address
    	end
  	end
end
