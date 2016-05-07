class TextController < ContentController

	def new
		localParams = ["video_id", "second", "user_id", "active", "description", "content"]
      	render new_content(params, localParams)
	end

end