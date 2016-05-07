class ContentController < MainController

	def deactivate()
		tokenValid = _isTokenValid(params)
		if tokenValid['bool']
			json = validateParams(params, ["id"])
			if json.nil?
				content = "#{params['controller']}".camelize.constantize.where("id=#{params[id]}")
				content.update_attribute(:active, false)
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

end