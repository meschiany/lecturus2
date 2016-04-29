class VideoController < MainController
	def upload
		puts params[:video].original_filename
		body = params[:video].read
		json = getJson("success", {"videoUrl" => "https://s3-ap-southeast-1.amazonaws.com/lecturus/videos/"+params[:id].to_s+".mp4"}, "show")
		video_temp_file = write_to_file(body)
		VideoUploader.new.upload_video_to_s3(video_temp_file, params[:id].to_s+'.mp4')
		render :json => json, :status => :ok
	end

	def write_to_file(content)
      thumbnail_file = Tempfile.new(['video','.mp4'])
      thumbnail_file.binmode # note that the tempfile must be in binary mode
      thumbnail_file.write content
      thumbnail_file.rewind
      thumbnail_file
    end

	def new
		params.store(:status, "#$STATUS_REC")
		params.store(:start_record_timestamp,Time.now.getutc)
		localParams = ["title", "master_id", "course_id", "status", "start_record_timestamp"]
		json = setNew("#{params['controller']}".camelize, params, localParams)
		render :json => json, :status => :ok
	end

	def end
    	json = validateParams(params, ["id", "length"])
    	if !json.nil?
			render :json => json, :status => :not_found
    	else
			vid = Video.find_by_id(params[:id])
			vid.end_record_timestamp = Time.now.getutc
			vid.status = "#$STATUS_EDIT"
			vid.length = params[:length]
			vid.save
			data = {"video_id" => vid.id, 
			  "end_record_timestamp" => vid.end_record_timestamp, 
			  "status" => vid.status, 
			  "length" => vid.length
			}
			json = getJson("success", data, "updated")
			render :json => json, :status => :ok
	    end
	end

end