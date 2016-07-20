class VideoController < MainController
	require 'fileutils'

	before_filter :authenticate_user

	def get
		user = get_user_by_token
		params.store('filters', {:master_id => user.id});
	    render :json => get_data("#{params['controller']}".camelize, "status"), :status => :ok
	end

	def get_live_videos
		return if get_user_by_token.nil?
		params.store 'filters', {:status => "RECORDING"};
	    render :json=> get_data("#{params['controller']}".camelize, "status"), :status => :ok
	end

	def new
		params.store("status", "RECORDING")

		user = get_user_by_token
		return if user.nil?
		
		params.store "master_id", user[:id]
		localParams = ["title", "course_id", "master_id", "status"]
		result = set_new "#{params['controller']}".camelize, localParams
		
		return if result.nil?
		
		# create directories hirarchy
		set_dirs result[:json]["data"].id
      	render result
	end

	def upload
		id = params[:id].to_s
		content = params[:video].read
		File.open(Rails.root.join('public','uploads/vits/'+id+'/parts/'+id+"_"+params[:index].to_s), 'wb') do |f| 
			f.write(content) 
		end
		
		update_start_record_time
		
		json = get_json "success", {"videoId" => params[:id], "index" => params[:index]}, "upload"
		result = {:json => json, :status => :ok}
		render result
	end

	def end

		json = validate_params ["id", "length"]
		if json.nil?

			close_and_upload

			data = update_video_record
			json = get_json "success", data, "updated"
			result = {:json => json, :status => :ok}
		else
			result = {:json => json, :status => :not_found}
		end
    	render result
	end

	def publish
		vid = Video.find(params[:id])
		vid.status = "#$STATUS_PUB"
		vid.save
		result = {"video_id" => vid.id, 
			"status" => vid.status, 
			"videoUrl" => "#/vitPlayer/"+vid.id.to_s
		}
		json = get_json "success", result, "published"
		result = {:json => json, :status => :ok}
      	render result
	end



	private

	def update_start_record_time
		if (params[:index].to_i==0)
			vid = Video.find(params[:id])
			if (vid.start_record_timestamp.nil?)
				vid.start_record_timestamp = Time.now.getutc
				vid.save
			end
		end
	end

	def update_video_record
		vid = Video.find(params[:id])
		vid.end_record_timestamp = Time.now.getutc
		vid.status = "#$STATUS_EDIT"
		vid.length = params[:length]
		vid.save
		return {"video_id" => vid.id, 
			"end_record_timestamp" => vid.end_record_timestamp, 
			"status" => vid.status, 
			"length" => vid.length,
			"videoUrl" => "http://54.149.212.63/vit/WebClientLecturus/app/#/editVideo/"+params[:id].to_s
		}
	end

	def close_and_upload
		file = File.open(Rails.root.join('public','uploads/vits/'+params[:id].to_s+'/video'+params[:id].to_s+'.mp4'), 'wb')

		for i in 0..(params[:parts].to_i-1)
   			temp = File.open(Rails.root.join('public','uploads/vits/'+params[:id].to_s+'/parts/'+params[:id].to_s+"_"+i.to_s), 'r')	
   			file.write(temp.read)
		end
		file.rewind

		# Working with s3 buckets
		# VideoUploader.new.upload_video_to_s3(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'), "video"+vidId.to_s+'.mp4')
		# File.unlink(Rails.root.join('app/assets/uploads/video'+vidId.to_s+'.mp4'))
	end

	def set_dirs vidId
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'))
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'+vidId.to_s))				# public/uploads/vits/6/video6.mp4
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'+vidId.to_s+'/files'))	# public/uploads/vits/6/parts/6_44
		FileUtils.mkdir_p(Rails.root.join('public','uploads/vits/'+vidId.to_s+'/parts'))	# public/uploads/vits/6/files
	end

	def set_new_temp_file
		id = params[:id].to_s
		file = File.new(Rails.root.join('public','uploads/vits/'+id+'/video'+id+'.mp4'), 'ab')
		file.binmode # note that the tempfile must be in binary mode
	end

end
