class VideoController < MainController
	def upload
		tokenValid = _isTokenValid(params)
    	if tokenValid['bool']
			puts params[:video].original_filename
			body = params[:video].read
			json = getJson("success", {"videoUrl" => "https://s3-ap-southeast-1.amazonaws.com/lecturus/videos/"+params[:id].to_s+".mp4"}, "show")
			video_temp_file = _write_to_file(body)
			VideoUploader.new.upload_video_to_s3(video_temp_file, params[:id].to_s+'.mp4')
			result = {:json => json, :status => :ok}
		else
			json = _getJson("failed", {}, tokenValid['msg'])
    		result = {:json => json, :status => :not_found}
		end
		render result
	end

	def _write_to_file(content)
      thumbnail_file = Tempfile.new(['video','.mp4'])
      thumbnail_file.binmode # note that the tempfile must be in binary mode
      thumbnail_file.write content
      thumbnail_file.rewind
      thumbnail_file
    end

	def new
		params.store(:status, "#$STATUS_REC")
		params.store(:start_record_timestamp, "#{Time.now.getutc}")
		localParams = ["title", "master_id", "course_id","token", "class", "status", "start_record_timestamp"]
		result = setNew("#{params['controller']}".camelize, params, localParams)
      	render result
	end

	def end
		tokenValid = _isTokenValid(params)
    	if tokenValid['bool']
			json = validateParams(params, ["id", "length"])
    		if json.nil?
				vid = Video.find_by_id(params[:id])
				vid.end_record_timestamp = Time.now.getutc
				vid.status = "#$STATUS_EDIT"
				vid.length = params[:length]
				vid.save
				data = {"video_id" => vid.id, 
				  "end_record_timestamp" => vid.end_record_timestamp, 
				  "status" => vid.status, 
				  "length" => vid.length,
				  "id" => params[:id]
				}
				json = getJson("success", data, "updated")
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