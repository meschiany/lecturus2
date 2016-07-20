class TextController < ContentController

	before_filter :authenticate_user

	def new
		user = get_user_by_token
		return if user.nil?
			
		params.store("user_id", user["id"])
		params.store("active", "true")
		params.store("content_type", "text")
		localParams = ["video_id", "second", "active", "content", "user_id"]
  		result = set_new "Post", localParams
		render result;

	end

	# contributor put text by timestamp
	def put_text
		user = get_user_by_token
		return if user.nil?
			
		vid = Video.find(params[:video_id])
		second = Time.now.getutc - vid.start_record_timestamp

		params.store("user_id", user["id"])
		params.store("active", "true")
		params.store("content_type", "text")
		params.store("second", second)
		
		localParams = ["video_id", "second", "content"]
  		result = set_new "Post", localParams
		
		render result;

	end

	def updater
		user = get_user_by_token
		return if user.nil?
			
		params.store(:user_id, user[:id])
		localParams = ["id", "second", "content", "user_id"]
		json = validate_params localParams
		if json.nil?
			result = {:json => update_text_content, :status => :ok}
		else
			result = {:json => json, :status => :not_found}
		end
		render result;

	end

	def get
		a = params["filters"]
		a.store("active","t")
		params.store("filters",a);
		super
	end



	private

	def update_text_content
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

end