class CourseController < MainController

	def new
		localParams = ["college_id", "name", "professor", "year", "semester"]
		result = setNew("#{params['controller']}".camelize, params, localParams)
		render result
	end

end