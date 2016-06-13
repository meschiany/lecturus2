class VideoController < MainController
	
	$test_file
	def get()
	    tokenValid = _isTokenValid(params)
	    if tokenValid['bool']
	      user = _getUserByToken(params);
	      params.store(:'filters', {:master_id => user.id});
	      json = _getData("#{params['controller']}".camelize, params)
	      result = {:json => json, :status => :ok}      
	    else
	      json = _getJson("failed", {}, tokenValid['msg'])
	      result = {:json => json, :status => :not_found}
	    end
	    render result
	end

	def _setNewTempFile
		file = File.new(Rails.root.join('app/assets/uploads/video'+params[:id].to_s+'.mp4'), 'ab')
		file.binmode # note that the tempfile must be in binary mode
	end

	def _closeAndUpload(vidId)
		file = File.open(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'), 'r')
		file.rewind
		VideoUploader.new.upload_video_to_s3(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'), "video"+vidId.to_s+'.mp4')
		File.unlink(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'))
	end

	def _updateVideoRecord(vidId, length)
		vid = Video.find_by_id(vidId)
		vid.end_record_timestamp = Time.now.getutc
		vid.status = "#$STATUS_EDIT"
		vid.length = length
		vid.save
		return {"video_id" => vid.id, 
			"end_record_timestamp" => vid.end_record_timestamp, 
			"status" => vid.status, 
			"length" => vid.length,
			"videoUrl" => "https://s3-ap-southeast-1.amazonaws.com/lecturus/videos/"+vidId.to_s+".mp4"
		}
	end


	def new
		params.store(:status, "#$STATUS_REC")
		params.store(:start_record_timestamp, "#{Time.now.getutc}")
		user = _getUserByToken(params)
		if params["debug"] == "true"
			user = User.first
		end
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store(:master_id, user[:id])
			localParams = ["title", "course_id", "master_id", "status", "start_record_timestamp"]
			result = setNew("#{params['controller']}".camelize, params, localParams)
			if result["bool"]
				_setNewTempFile()
			end
		end
      	render result
	end

	def _write_to_local
		content = params[:video].read
		File.open(Rails.root.join('app/assets/uploads/'+params[:id].to_s+"_"+params[:index].to_s), 'wb') do |f| 
			f.write(content) 
		end
		head :ok
	end

	def upload
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']
			content = params[:video].read
			# $test_file.write content
			# file = File.open(Rails.root.join('app/assets/uploads/'+params[:id].to_s+"_"+params[:index].to_s), 'wb') do |f| 
			File.open(Rails.root.join('app/assets/uploads/'+params[:id].to_s+"_"+params[:index].to_s), 'ab') do |f| 
				f.write(content) 
			end
			File.open(Rails.root.join('app/assets/uploads/video'+params[:id].to_s+'.mp4'), 'ab') do |f| 
				f.write(content) 
			end

			json = _getJson("success", {"videoId" => params[:id], "index" => params[:index]}, "upload")
			
			result = {:json => json, :status => :ok}
		else
			json = _getJson("failed", {}, tokenValid['msg'])
    		result = {:json => json, :status => :not_found}
		end
		render result
	end

	def end
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']
			json = validateParams(params, ["id", "length"])
			if json.nil?

				_closeAndUpload(params[:id].to_s)

				data = _updateVideoRecord(params[:id],params[:length])
				json = _getJson("success", data, "updated")
				result = {:json => json, :status => :ok}
			else
				result = {:json => json, :status => :not_found}
			end
		else
			json = _getJson("failed", {}, tokenValid['msg'])
      		result = {:json => json, :status => :not_found}
		end
    	render result
	end

end