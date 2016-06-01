class CollegeController < MainController
	
	def new
		localParams = ["name"]
		result = setNew("#{params['controller']}".camelize, params, localParams)
		render result
	end

	def get()
      	json = _getData("#{params['controller']}".camelize, params)
      	result = {:json => json, :status => :ok}      
    	render result
  	end

  	def show()
  		college = "#{params['controller']}".camelize.constantize.find_by_id(params[:id])
  		if college
    		json = _getJson("success", college, "show")
    		result = {:json => json, :status => :ok}
  		else
    		json = {"msg"=>"not found"}
    		result = {:json => {"msg"=>"not found"}, :status => :not_found}
  		end
    	render result
  	end

end