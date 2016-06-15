class TextController < ContentController

	def new
		# check token
		user = _getUserByToken(params)
		if user.nil?
			json = _getJson("failed", {}, 'no user with this token')
    		result = {:json => json, :status => :not_found}
		else
			params.store(:user_id, user[:id])
			params.store(:active, "true")
			localParams = ["video_id", "second", "active", "content", "user_id"]
      		result = setNew("#{params['controller']}".camelize, params, localParams)
		end
		render result;

	end

# TODO finish update (for everything but now test the change in second and update gui)
# later add update btn for the content itself delete btn and deactivate btm
#  all as links and maybe seperate the api calls
# swich on all params and update each one at a time
	def _updateTextContent(params)
		puts 6
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
			params.store(:active, "true")
			localParams = ["id", "second", "active", "content", "user_id"]
			json = validateParams(params, localParams)
			if json.nil?
				result = {:json => _updateTextContent(params), :status => :ok}
			else
				result = {:json => json, :status => :not_found}
			end
		end
		render result;

	end

end