class UserController < MainController
require 'digest/sha1'

	def show
		localParams = ["token"]
		json = validate_params localParams
		if json.nil?
			users = User.where("token='#{params["token"]}'")
			if users.size > 0
				params = users
				json = get_json "success",params, "Only self"
			else
				json = get_json "success",params, "no active session"
			end
		end
    	render :json => json, :status => :ok

	end

	def new
		result = check_exists
		if !result.nil?
			render result and return
		end

		localParams = ["email", "f_name", "l_name", "college_id", "password"]
		result = set_new "#{params['controller']}".camelize, localParams
		if (result[:status] === :ok)
			params["link"] = "https://s3-ap-southeast-1.amazonaws.com/lecturus/VITClient.jar";
    		# json = get_json("success",params,"login success");
    		# render :json => json, :status => :ok
    		# Shlomi dont want auto login
			login params["email"], params["password"]
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
		json = validate_params localParams
    	if json.nil?
    		users = User.where("email='#{params['email']}' AND password='#{params['password']}'")
    		if users.size>0
    			params["token"] = users[0].token;
    			tokenRes = is_token_valid
    			if !tokenRes["bool"]
    				token = Digest::SHA1.hexdigest("#{params['email']}-#{Time.now.to_i}-#{rand}")
    				users[0].update_attributes(:token => token, :last_login_timestamp => Time.now)
    			else
    				token=users[0].token
    			end
				
    			params["token"] = token;
    			json = get_json "success",params,"login success"
    		else
    			json = get_json "failed",params,"Wrong user name or password"
    		end
    	end
    	render :json => json, :status => :ok
	end

	def logout
		localParams = ["token"]
		json = validate_params localParams
    	if json.nil?
    		users = User.where("token='#{params["token"]}'")
    		if users.size>0
				users[0].update_attribute(:token, "")
    			json = get_json "success",params,"logout success"
    		else
    			json = get_json"success",params,"no session was found with this token"
    		end
    	end
    	render :json => json, :status => :ok
	end

	def auth
		tokenRes = is_token_valid
		json = get_json(tokenRes["bool"] ? "success" : "failed" ,params ,tokenRes["msg"])
		render :json => json, :status => :ok 
	end





	private

	def check_exists
		email = params[:email]
		result = nil
		user = User.find_by_email(email)
		if !user.nil?
			json = get_json "failed",{},"User already exists"
			result = {:json => json, :status => :ok}
		end
		return result
	end

end