class ContentController < MainController

	before_filter :authenticate_user
	
	def deactivate
		json = validate_params(["id"])
		if json.nil?
			content = "#{params['controller']}".camelize.constantize.find(params[:id])
			content.active = false
			content.save
			json = get_json "success", params, "updated"
			result = {:json => json, :status => :ok}
		else
			result = {:json => json, :status => :not_found}
		end
      	render result
	end

	def get_content
		json = validate_params(["filters"])
		if json.nil?
			content = []
			a = params["filters"]
			a.store("active","t")
			params.store("filters",a)


			texts = get_data "Text"
			# texts["data"].each {|item| item[:c_type] = "text"}
			
			posts = get_data "Post"
			# posts["data"].each {|item| item[:c_type] = "post"}
			
			content.push(*texts["data"])
			content.push(*posts["data"])
			content.each{|c|
				if c.content_type == "file"
					c.content = 'http://52.23.174.169:3000/uploads/vits/'+c.video_id.to_s+'/files/'+c.content
				end
			}
			json = get_json "success", content, "updated"
			result = {:json => json, :status => :ok}
		end

		render result
	end


	private

	# def new_content(params, localParams)
	# 	tokenValid = is_token_valid
	# 	if tokenValid['bool']			
	# 		json = set_new("#{params['controller']}".camelize, localParams)
	# 		result = {:json => json, :status => :ok}
	# 	else
	# 		json = get_json("failed", {}, tokenValid['msg'])
 #      		result = {:json => json, :status => :not_found}
	# 	end
 #      	return result
	# end

end