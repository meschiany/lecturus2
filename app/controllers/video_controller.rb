class VideoController < MainController
	
	$test_file

	def _setNewTempFile
		$test_file = Tempfile.new(['video','.mp4'])
		$test_file.binmode # note that the tempfile must be in binary mode
	end

	def _closeAndUpload()
		$test_file.rewind
		$test_file
		VideoUploader.new.upload_video_to_s3($test_file, vidId.to_s+'.mp4')
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
			"videoUrl" => "https://s3-ap-southeast-1.amazonaws.com/lecturus/videos/"+vid+".mp4"
		}
	end


	def new
		_setNewTempFile()

		params.store(:status, "#$STATUS_REC")
		params.store(:start_record_timestamp, "#{Time.now.getutc}")
		localParams = ["title", "master_id", "course_id","token", "class", "status", "start_record_timestamp"]
		result = setNew("#{params['controller']}".camelize, params, localParams)
      	render result
	end

	def _write_to_local
		content = params[:video].read
		File.open(Rails.root.join('app/assets/uploads/',params[:id].to_s+"_"+params[:index].to_s), 'wb') do |f| 
			f.write(content) 
		end
		head :ok
	end

	def upload
		tokenValid = _isTokenValid(params)
		# if tokenValid['bool']
			content = params[:video].read
			$test_file.write content
			File.open(Rails.root.join('app/assets/uploads/',params[:id].to_s+"_"+params[:index].to_s), 'wb') do |f| 
				f.write(content) 
			end

			json = _getJson("success", {"videoId" => params[:id], "index" => params[:index]}, "upload")
			
			result = {:json => json, :status => :ok}
		# else
			# json = _getJson("failed", {}, tokenValid['msg'])
    		# result = {:json => json, :status => :not_found}
		# end
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