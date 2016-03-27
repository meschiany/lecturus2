class VideoController < MainController
	def show
		vid = Video.find_by_id(params[:id])
		if vid
			render :json => {"vidId" => vid.id, "title" => vid.title}, :status => :ok
		else
			render :json => {"msg"=>"not found"}, :status => :not_found
		end
	end

	def new
		json = validateParams(params, "title")
		if !json.nil?
			render :json => json, :status => :not_found
		end


		# :end_record_timestamp, :course_id, :length, :status
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

  	def end

  	end

  	def validateParams(params, param)
  		title = params[param]
  		if !title || !title == ""
  			return getJson("failed", params, "missing "+param)
  		end

  		# master_id = params[:master_id]
  		# if !title || !title == ""
  			# return getJson("failed", params, "missing user_id")
  		# end

  		# course_id
  	end
end

