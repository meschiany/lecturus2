class PostController < MainController

	def new
		localParams = ["video_id", "second", "user_id", "post_type", "text", "active"]
		json = setNew("#{params['controller']}".camelize, params, localParams)
		render :json => json, :status => :ok
	end

end