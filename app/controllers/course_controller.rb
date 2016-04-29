class CourseController < MainController

	def new
		localParams = ["college_id", "name", "professor", "year", "semester"]
		json = setNew("#{params['controller']}".camelize, params, localParams)
		render :json => json, :status => :ok
	end

end