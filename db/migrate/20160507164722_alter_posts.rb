class AlterPosts < ActiveRecord::Migration
	def change
    	change_table :posts do |t|
      		t.rename :text, :description
			t.rename :f_type, :file_type
			t.rename :f_name, :file_name
			t.remove :post_type
    	end
  	end
end
