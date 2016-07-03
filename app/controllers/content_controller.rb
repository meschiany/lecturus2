class ContentController < MainController

	def deactivate()
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']
			json = validateParams(params, ["id"])
			if json.nil?
				content = "#{params['controller']}".camelize.constantize.find(params[:id])
				content.active = false
				content.save
				json = _getJson("success", params, "updated")
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

	def new_content(params, localParams)
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']			
			json = setNew("#{params['controller']}".camelize, params, localParams)
			result = {:json => json, :status => :ok}
		else
			json = _getJson("failed", {}, tokenValid['msg'])
      		result = {:json => json, :status => :not_found}
		end
      	return result
	end

	def get_content
		# result = {:json => {}, :status => :not_found}
		# render result
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']
			json = validateParams(params, ["filters"])
			if json.nil?
				content = []
				a = params["filters"]
				a.store("active","t")
				params.store("filters",a)


				texts = _getData("Text", params)
				# texts["data"].each {|item| item[:c_type] = "text"}
				
				posts = _getData("Post", params)
				# posts["data"].each {|item| item[:c_type] = "post"}
				
				content.push(*texts["data"])
				content.push(*posts["data"])
				content.each{|c|
					if c.content_type == "file"
						c.content = 'http://52.23.174.169:3000/uploads/vits/65/files/'+c.content
					end
				}
				json = _getJson("success", content, "updated")
				result = {:json => json, :status => :ok}
			end
		else
			json = _getJson("failed", {}, tokenValid['msg'])
      		result = {:json => json, :status => :not_found}
		end
		render result
	end


end