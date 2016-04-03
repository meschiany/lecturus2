class PostController < MainController

	def show
		post = Post.find_by_id(params[:id])
		if post
      		json = getJson("success", post, "show")
			render :json => json, :status => :ok
		else
			render :json => {"msg"=>"not found"}, :status => :not_found
		end
	end

	def new
		json = validateParams(params,["video_id", "second", "user_id", "type", "text"])
		if !json.nil?
			render :json => json, :status => :not_found
		else
			post = Post.new(video_id: "#{params[:video_id]}", 
				second: "#{params[:second]}",
				post_type: "#{params[:type]}",
				text: "#{params[:text]}",
				user_id: "#{params[:user_id]}",
				active: true)

			post.save
			data = {"video_id" => params[:video_id], 
				"second" => params[:second], 
				"user_id" => params[:user_id], 
				"type" => params[:type], 
				"text" => params[:text],
				"active" => true
			}
			json = getJson("success", data, "saved")
			render :json => json, :status => :ok
		end
	end

	def get_by_video_id
		json = validateParams(params,["video_id"])
		if !json.nil?
			render :json => json, :status => :not_found
		else
			posts = Post.where(video_id: "#{params[:video_id]}")
			json = getJson("success", posts, "get by video_id=#{params[:video_id]}")
			render :json => json, :status => :ok
		end
	end

end