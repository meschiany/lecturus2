class PostController < ContentController

	def new
		json = _getJson("failed", {}, "use upload request")
    	result = {:json => json, :status => :not_found}
	end

	def new_post(params)
		render new_content(params, localParams)
	end

	def upload
		
		tokenValid = _isTokenValid(params)
		if !tokenValid['bool']
			json = _getJson("failed", {}, tokenValid['msg'])
    		result = {:json => json, :status => :not_found}

		end
		
		localParams = ["video_id", "second", "user_id", "active", "description", "file_type"]
		json = validateParams(params,localParams)
		if json.nil?
			new_post(params)
		
			file_name = params[:image].original_filename
			body = params[:image].read
			file_type = params[:file_type]
			address = "https://s3-ap-southeast-1.amazonaws.com/lecturus/images/"+params[:id].to_s+"/"+file_name

			json = _getJson("success", {"fileUrl" => address}, "show")
			video_temp_file = _write_to_file(body,file_type)
			ImageUploader.new.upload_video_to_s3(video_temp_file, params[:id].to_s+"/"+file_name)
			post = Post.last
			post.update_attribute(:address, address)
			result = {:json => json, :status => :ok}
		end
		render result

	end

	def _write_to_file(content,file_type)
		thumbnail_file = Tempfile.new(['image',"."+file_type])
    	thumbnail_file.binmode # note that the tempfile must be in binary mode
    	thumbnail_file.write content
    	thumbnail_file.rewind
    	thumbnail_file
	end

end