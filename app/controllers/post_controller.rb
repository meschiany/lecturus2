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
				user_id: "#{params[:user_id]}",
				type: "#{params[:type]}",
				text: "#{params[:text]}")
			post.save
			data = {"video_id" => params[:video_id], 
				"second" => params[:second], 
				"user_id" => params[:user_id], 
				"type" => params[:type], 
				"text" => params[:text]
			}
			json = getJson("success", data, "saved")
			render :json => json, :status => :ok
		end
	end

end