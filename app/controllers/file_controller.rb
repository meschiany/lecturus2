class FileController < ContentController

	def new
		localParams = ["video_id", "second", "user_id", "active", "description", "file_type", "file_name"]
		render new_content(params, localParams)
	end

end