class CollegeController < MainController
	
	def new
		localParams = ["name"]
		json = setNew("#{params['controller']}".camelize, params, localParams)
		render :json => json, :status => :ok
	end

end