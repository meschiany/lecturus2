class PostController < ContentController

	def new_file
		# check token
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store("user_id", user["id"])
			params.store("active", "true")
			params.store("content_type", "file")
			file_name = params[:file].original_filename
			params.store("content", file_name)
			localParams = ["content", "video_id", "second", "user_id"]
      		result = setNew("#{params['controller']}".camelize, params, localParams)
      		content = params[:file].read
      		id = params[:video_id].to_s
      		File.open(Rails.root.join('public','uploads/vits/'+id+'/files/'+file_name), 'wb') do |f| 
				f.write(content) 
			end
		end
		render result
	end

	# contributor put file by timestamp
	def put_file
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			file_name = params[:file].original_filename

			vid = Video.find(params[:video_id])
			second = (Time.now.getutc - vid.start_record_timestamp).to_i

			params.store("content", file_name)
			params.store("user_id", user["id"])
			params.store("active", "true")
			params.store("content_type", "file")
			params.store("second", second)

			localParams = ["video_id", "second", "content"]
      		result = setNew("Post", params, localParams)
      		content = params[:file].read
      		id = params[:video_id].to_s
      		File.open(Rails.root.join('public','uploads/vits/'+id+'/files/'+file_name), 'wb') do |f| 
				f.write(content) 
			end
		end
		render result
	end

	def upload_file
		# check token
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			file_name = params[:file].original_filename
			content = params[:file].read
			

			id = params[:video_id].to_s
			File.open(Rails.root.join('public','uploads/vits/'+id+'/files/'+file_name), 'wb') do |f| 
				f.write(content) 
			end
			json = _getJson("success", {}, "file upload")
			result = {:json => json, :status => :ok}
		end
		render result
	end

	def new
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store("user_id", user["id"])
			params.store("active", "true")
			params.store("content_type", "text")
			localParams = ["content", "video_id", "second", "user_id"]
      		result = setNew("#{params['controller']}".camelize, params, localParams)
		end
		render result
	end

	def new_post(params)
		render new_content(params, localParams)
	end
# s3 bucket
	# def upload
		
	# 	tokenValid = _isTokenValid(params)
	# 	if !tokenValid['bool']
	# 		json = _getJson("failed", {}, tokenValid['msg'])
 #    		result = {:json => json, :status => :not_found}

	# 	end
		
	# 	localParams = ["video_id", "second", "user_id", "active"]
	# 	json = validateParams(params,localParams)
	# 	if json.nil?
	# 		new_post(params)
		
	# 		file_name = params[:image].original_filename
	# 		body = params[:image].read
	# 		file_type = params[:file_type]
	# 		address = "https://s3-ap-southeast-1.amazonaws.com/lecturus/images/"+params[:id].to_s+"/"+file_name

	# 		json = _getJson("success", {"fileUrl" => address}, "show")
	# 		video_temp_file = _write_to_file(body,file_type)
	# 		ImageUploader.new.upload_video_to_s3(video_temp_file, params[:id].to_s+"/"+file_name)
	# 		post = Post.last
	# 		post.update_attribute(:address, address)
	# 		result = {:json => json, :status => :ok}
	# 	end
	# 	render result	

	# end

	def _write_to_file(content,file_type)
		thumbnail_file = Tempfile.new(['image',"."+file_type])
    	thumbnail_file.binmode # note that the tempfile must be in binary mode
    	thumbnail_file.write content
    	thumbnail_file.rewind
    	thumbnail_file
	end

	def get
		tmp = params["filters"]
		tmp.store("active","t")
		params.store("filters",tmp);
		super
	end

	def _updateContent(params)
		txt = Post.find(params[:id])
		puts txt
		params.each{|key, value| puts "#{key} is #{value}" 
			txt[key] = value
			}
		txt.save
		return {"text_id" => txt.id,
				"second" => txt.second,
				"active" => txt.active,
				"content" => txt.content
		}
	end

	def updater
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store(:user_id, user[:id])
			localParams = ["id", "second", "content", "user_id"]
			json = validateParams(params, localParams)
			if json.nil?
				result = {:json => _updateContent(params), :status => :ok}
			else
				result = {:json => json, :status => :not_found}
			end
		end
		render result;

	end

end