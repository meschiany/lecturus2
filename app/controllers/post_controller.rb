class PostController < MainController

	def new
		if _isTokenValid(params)
			localParams = ["video_id", "second", "user_id", "post_type", "text", "active"]
			json = setNew("#{params['controller']}".camelize, params, localParams)
			result = {:json => json, :status => :ok}
		else
			json = _getJson("failed", {}, "No valid token was sent")
      		result = {:json => json, :status => :not_found}
		end
      	render result
	end

end