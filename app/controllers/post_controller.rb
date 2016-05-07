class PostController < MainController

	def new
		tokenValid = _isTokenValid(params)
    	if tokenValid['bool']
			localParams = ["video_id", "second", "user_id", "post_type", "text", "active"]
			json = setNew("#{params['controller']}".camelize, params, localParams)
			result = {:json => json, :status => :ok}
		else
			json = _getJson("failed", {}, tokenValid['msg'])
      		result = {:json => json, :status => :not_found}
		end
      	render result
	end

end