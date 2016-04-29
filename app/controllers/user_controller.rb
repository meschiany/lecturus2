class UserController < MainController

	def new
		localParams = ["email", "f_name", "l_name", "college_id", "password"]
		json = setNew("#{params['controller']}".camelize, params, localParams)
		render :json => json, :status => :ok
	end

end