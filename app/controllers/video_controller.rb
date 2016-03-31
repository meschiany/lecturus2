class VideoController < MainController

	def show
		vid = Video.find_by_id(params[:id])
		if vid
      json = getJson("success", vid, "show")
			render :json => json, :status => :ok
		else
			render :json => {"msg"=>"not found"}, :status => :not_found
		end
	end

	def upload
		body = request.body.read
		json = getJson("success", {"content" => "Base64 stuff"}, "show")
		
		vid = Base64.decode64(body)
		video_temp_file = write_to_file(vid)
		VideoUploader.new.upload_video_to_s3(video_temp_file, params[:id].to_s+'.mp4')
		# File.open(Rails.root.join('public/uploads/'+params[:id].to_s+'.mp4'), 'wb') { |f| f.write(vid) }
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
		json = validateParams(params,["title", "master_id", "course_id"])
		if !json.nil?
			render :json => json, :status => :not_found
		else
      
			vid = Video.new(title: "#{params[:title]}", master_id: "#{params[:master_id]}",
				start_record_timestamp: Time.now.getutc,
				course_id: "#{params[:course_id]}",
				status: "#$STATUS_REC")
			vid.save
			data = {"video_id" => vid.id, 
				"title" => vid.title, 
				"master_id" => "#{params[:master_id]}", 
				"start_record_timestamp" => Time.now.getutc,
				"course_id" => "#{params[:course_id]}",
				"status" => "#$STATUS_REC"
			}
			json = getJson("success", data, "saved")
			render :json => json, :status => :ok
		end
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