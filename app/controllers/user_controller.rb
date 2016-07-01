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

	def checkExists(email)
		result = nil
		user = User.find_by_email(email)
		if !user.nil?
			json = _getJson("failed",{},"User already exists");
			result={:json => json, :status => :ok}
		end
		return result
	end

	def new
		result = checkExists(params[:email])
		if !result.nil?
			render result
			return
		end

		localParams = ["email", "f_name", "l_name", "college_id", "password"]
		result = setNew("#{params['controller']}".camelize, params, localParams, false)
		if (result[:status] === :ok)
			params["token"] = "token";
			params["link"] = "https://s3-ap-southeast-1.amazonaws.com/lecturus/VITClient.jar";
    		json = _getJson("success",params,"login success");
    		render :json => json, :status => :ok
    		# Shlomi dont want auto login
			# login(params["email"], params["password"])
		else
			render result
		end
	end

	def login(email = nil, password = nil)
		if !email.nil? && !password.nil?
			params["email"] =  email
			params["password"] = password
		end
		localParams = ["email", "password"]
		json = validateParams(params,localParams)
    	if json.nil?
    		users = User.where("email='#{params['email']}' AND password='#{params['password']}'")
    		if users.size>0
    			token = Digest::SHA1.hexdigest("#{params['email']}-#{Time.now.to_i}-#{rand}")
				users[0].update_attributes(:token => token, :last_login_timestamp => Time.now)
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

	def auth
		tokenRes = _isTokenValid(params)
		json = _getJson(tokenRes["bool"] ? "success" : "failed" ,params ,tokenRes["msg"])
		render :json => json, :status => :ok 
	end

end