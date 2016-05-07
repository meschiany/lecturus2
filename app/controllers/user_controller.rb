class UserController < MainController
require 'digest/sha1'

	def show
		localParams = ["token"]
		json = validateParams(params,localParams)
		if json.nil?
			users = User.where("token='#{params["token"]}'")
			if users.size > 0
				params = users
				json = _getJson("success",params, "Only self")
			else
				json = _getJson("success",params, "no active session")
			end
		end
    	render :json => json, :status => :ok

	end

	def setNew(className, params, localParams)
		json = validateParams(params,localParams)
		if json.nil?

			values = params.values
			record = className.constantize.new
			record[:"#{localParams[0]}"] = values[0]
			data = {localParams[0] => values[0]}
			if (localParams.length > 1)
			    localParams[1..-1].each.with_index(1) do |item,i|
			      record[:"#{localParams[i]}"] = values[i]
			      data.store(:"#{localParams[i]}", values[i])
			    end 
			end
			record.save
			data.store(:id, record.id)
			json = _getJson("success", data, "saved")
			result = {:json => json, :status => :ok}
		end
		result = {:json => json, :status => :not_found}
		return result
	end



	def new
		localParams = ["email", "f_name", "l_name", "college_id", "password"]
		json = setNew("#{params['controller']}".camelize, params, localParams)
		render :json => json, :status => :ok
	end

	def auth
		localParams = ["email", "password"]
		json = validateParams(params,localParams)
    	if json.nil?
    		users = User.where("email='#{params['email']}' AND password='#{params['password']}'")
    		if users.size>0
    			token = Digest::SHA1.hexdigest("#{params['email']}-#{Time.now.to_i}-#{rand}")
				users[0].update_attributes(:token => token, :last_login_timestamp => Time.now.to_i)
    			params["token"] = token;
    			json = _getJson("success",params,"login success");
    		else
    			json = _getJson("failed",params,"Wrong user name or password")
    		end
    	end
    	render :json => json, :status => :ok
	end

	def logout
		localParams = ["token"]
		json = validateParams(params,localParams)
    	if json.nil?
    		users = User.where("token='#{params["token"]}'")
    		if users.size>0
				users[0].update_attribute(:token, "")
    			json = _getJson("success",params,"logout success");
    		else
    			json = _getJson("success",params,"no session was found with this token")
    		end
    	end
    	render :json => json, :status => :ok
	end

	def validate
		tokenRes = _isTokenValid(params)
		json = _getJson(tokenRes["bool"] ? "success" : "failed" ,params ,tokenRes["msg"])
		render :json => json, :status => :ok 
	end

end