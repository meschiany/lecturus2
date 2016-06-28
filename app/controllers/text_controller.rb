class TextController < ContentController

	def new
		# check token
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store("user_id", user["id"])
			params.store("active", "true")
			params.store("content_type", "text")
			localParams = ["video_id", "second", "active", "content", "user_id"]
      		result = setNew("Post", params, localParams)
		end
		render result;

	end

	# contributor put text by timestamp
	def put_text
		# check token
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			vid = Video.find(params[:video_id])
			second = Time.now.getutc - vid.start_record_timestamp

			params.store("user_id", user["id"])
			params.store("active", "true")
			params.store("content_type", "text")
			params.store("second", second)
			
			localParams = ["video_id", "second", "content"]
      		result = setNew("Post", params, localParams)
		end
		render result;

	end

	def _updateTextContent(params)
		txt = Text.find(params[:id])
		txt.second = params[:second]
		txt.active = params[:active]
		txt.content = params[:content]
		txt.save
		return {"text_id" => txt.id,
				"second" => txt.second,
				"active" => txt.active,
				"content" => txt.content
		}
	end

	def updater
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store(:user_id, user[:id])
			localParams = ["id", "second", "content", "user_id"]
			json = validateParams(params, localParams)
			if json.nil?
				result = {:json => _updateTextContent(params), :status => :ok}
			else
				result = {:json => json, :status => :not_found}
			end
		end
		render result;

	end

	def get
		a = params["filters"]
		a.store("active","t")
		params.store("filters",a);
		super
	end

end