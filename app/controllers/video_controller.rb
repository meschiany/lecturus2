class VideoController < MainController
	require 'fileutils'
	def get
	    tokenValid = _isTokenValid(params)
	    if params[:debug] == "true"
	    	json = _getData("#{params['controller']}".camelize, params)
	      	result = {:json => json, :status => :ok}      
	    elsif _isTokenValid(params)
	      user = _getUserByToken(params);
	      params.store('filters', {:master_id => user.id});
	      json = _getData("#{params['controller']}".camelize, params)
	      result ={:json=>json,:status => :ok}
	    else
	      json = _getJson("failed", {}, tokenValid['msg'])
	      result = {:json => json, :status => :not_found}
	    end
	    render result
	end

	def setDirs(vidId)

		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'))
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'+vidId.to_s))				# public/uploads/vits/6/video6.mp4
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'+vidId.to_s+'/files'))	# public/uploads/vits/6/parts/6_44
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'+vidId.to_s+'/parts'))	# public/uploads/vits/6/files
	end

	def _setNewTempFile
		id = params[:id].to_s
		file = File.new(Rails.root.join('public','uploads/vits/'+id+'/video'+id+'.mp4'), 'ab')
		file.binmode # note that the tempfile must be in binary mode
	end

	def _closeAndUpload(vidId,parts)
		file = File.open(Rails.root.join('public','uploads/vits/video'+vidId.to_s+'.mp4'), 'wb')

		for i in 0..(parts.to_i-1)
   			temp = File.open(Rails.root.join('public','uploads/vits/'+vidId.to_s+'/parts/'+vidId.to_s+"_"+i.to_s), 'r')	
   			file.write(temp.read)
		end
		file.rewind
		# VideoUploader.new.upload_video_to_s3(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'), "video"+vidId.to_s+'.mp4')
		# File.unlink(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'))
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
			"videoUrl" => "http://52.23.174.169:3000/uploads/vits/"+vidId.to_s+"/video"+vidId.to_s+".mp4"
		}
	end

	def new
		# params.store(:status, "#$STATUS_REC")
		params.store("status", "RECORDING")
		
		user = _getUserByToken(params)
		if params["debug"] == "true"
			user = User.first
		end
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store("master_id", user[:id])
			localParams = ["title", "course_id", "master_id", "status"]
			result = setNew("#{params['controller']}".camelize, params, localParams)
			# create directories hirarchy
			setDirs(result[:json]["data"].id)

			# if result["bool"]
				# _setNewTempFile()
			# end
		end
      	render result
	end

	# def _write_to_local
	# 	content = params[:video].read
	# 	File.open(Rails.root.join('app/assets/uploads/'+params[:id].to_s+"_"+params[:index].to_s), 'ab') do |f| 
	# 		f.write(content) 
	# 	end
	# 	head :ok
	# end
	def updateStartRecordTime(params)
		if (params[:index]==0)
			vid = Video.find(params[:id])
			vid.start_record_timestamp = Time.now.getutc.to_s
			vid.save
		end
	end

	def upload
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']
			id = params[:id].to_s
			content = params[:video].read
			File.open(Rails.root.join('public','uploads/vits/'+id+'/parts/'+id+"_"+params[:index].to_s), 'wb') do |f| 
				f.write(content) 
			end
			
			updateStartRecordTime(params)	
			
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

				_closeAndUpload(params[:id].to_s,params[:parts])

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
