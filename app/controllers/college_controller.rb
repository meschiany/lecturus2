class CollegeController < MainController
	
	def new
		localParams = ["name"]
		result = set_new "#{params['controller']}".camelize, localParams
		render result
	end

	def get
      	json = get_data "#{params['controller']}".camelize
  		result = {:json => json, :status => :ok}      
  		render result
	end

  	def show
  		college = "#{params['controller']}".camelize.constantize.find_by_id(params[:id])
		if college
  			json = get_json "success", college, "show"
  			result = {:json => json, :status => :ok}
		else
  			json = {"msg"=>"not found"}
  			result = {:json => {"msg"=>"not found"}, :status => :not_found}
		end
  	render result
	end

end