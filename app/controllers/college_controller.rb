class CollegeController < MainController
	
	def new
		localParams = ["name"]
		result = setNew("#{params['controller']}".camelize, params, localParams)
		render result
	end

end