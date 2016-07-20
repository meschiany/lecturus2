# change private to private section 
# no need to pass params
# no need for  duplicate call is_token_valid
# before_filter :authenticate_user! run before any api request 
# no need for () on func call
# no camel case
# no _ before privat
# one line if -> return json if !json.nil?

class MainController < ApplicationController
  require 'json'

  after_filter :set_access_control_headers

  $STATUS_REC = "RECORDING"
  $STATUS_EDIT = "EDITING"
  $STATUS_PUB = "PUBLISHED"

  def authenticate_user
    @tokenValid = is_token_valid
    if @tokenValid["bool"] == false 
      result = {:json => {:status => "failed", :data => {}, :msg => @tokenValid["msg"]}, :status => :ok}
      render result and return nil
    end
    @tokenValid
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def test
  end


  def show
    return if authenticate_user.nil?
    
    vid = "#{params['controller']}".camelize.constantize.find_by_id(params[:id])
    result = {:json => {"msg"=>"not found"}, :status => :not_found}
    
    if vid
      json = get_json "success", vid, "show"
      result = {:json => json, :status => :ok}   
    end

    render result
  end

  def get
    return if authenticate_user.nil?
    json = get_data "#{params['controller']}".camelize
    result = {:json => json, :status => :ok}
    render result
  end

# ----------------------------------
  private 

  def is_session_time_valid(user)
    if (user['last_login_timestamp'].to_i)+86400 < Time.now.to_i
      result = {"bool" => false, "msg" => "session timed out"}
      user.update_attribute(:token, "")
    else
      result = {"bool" => true, "msg" => "valid"}
    end
    return result 
  end

  # def ffmpeg
  #   @path ||= File.expand_path(`which melt`)
  #   video1 = S3Helper.get_file(name)
  #   video2 = S3Helper.get_file(name)
  #   outputfile = VideoProcessor.new("concat:61.mp4|61.mp4")
  #   VideoUploader.new.upload_video_to_s3(outputfile, 'out1.mp4')
  # end

  def get_user_by_token
    if params["debug"] == "true"
      user = User.first
    else
      user = User.where("token='#{params["token"]}'").first
    end
    if user.nil?
      json = get_json "failed", {}, 'no user with this token'
      result = {:json => json, :status => :not_found}
      render result and return nil
    end
    return user
  end

  def get_data className, orderParam=nil
    tmpParams = params.except(:action, :controller)
    if tmpParams.length <= 0 || (tmpParams.length == 1 && (!tmpParams[:debug].nil? || !tmpParams[:token].nil?))
      posts = "#{className}".constantize.all
      json = get_json "success", posts, "get all"
      return json
    end

    json = validate_filters "#{className}".constantize
    return json if !json.nil?

    if params["filters"].nil? 
      posts = "#{className}".constantize.all
      str = "get all"
    else
      if !orderParam.nil?
        posts = "#{className}".constantize.where(compose_query).order(orderParam+" ASC")
      else
        posts = "#{className}".constantize.where(compose_query)
      end
      
      str = "get by "+compose_query
    end
    json = get_json "success", posts, str
  
    return json
  end

  def is_token_valid
    if params["debug"] == "true"
      result = {"bool" => true, "msg" => "Debug no token needed"}
      return result
    end
    if !params["token"] || params["token"] == "" || params["token"].nil?
      result = {"bool" => false, "msg" => "no token was sent"}
    else
      user = User.where("token='#{params['token']}'")
      if user.size<=0
        result = {"bool" => false, "msg" => "no session with this token"}
      else
        result = is_session_time_valid(user[0])
      end
    end
    return result
  end

  def set_new className, localParams

    json = validate_params(localParams)
    if params.has_key?(:debug)
      params.delete("debug")
    end
    if params.has_key?(:token) && (params[:token]== "" || params[:token].nil?)
      params.delete("token")
    end
    if json.nil?

      keys = params.keys
      record = className.constantize.new
      keys.each { |key| 
        if className.constantize.column_names.include? key
          record[key] = params[key]
        end
      }
      record.save
      # data.store(:id, record.id)
      json = get_json "success", record, "saved"
      result = {:json => json, :status => :ok}
    else
      result = {:json => json, :status => :not_found}
    end

    puts result
    return result
  end

    # should be private
  def compose_query
    @compose_query ||= "#{params['filters'].map { |k, v| "#{k}='#{v}'" }.join(' AND ')}"
  end

    def get_json(status, data, msg)
    return {"status" => status, "data" => data, "msg" => msg}
  end

  def validate_params(param_to_check)
    param_to_check.each do |k, v|
      data = params[k]
      if !data || !data == "" || data.nil?
        return get_json "failed", params, "missing "+k
      end
    end
    return nil
  end

  # public main
  def filter_exists?
    @filter_exists ||= params["filters"].nil?
  end

  def validate_filters className
    json = nil
    if filter_exists?
      keys=[]
    else
      keys = params["filters"].keys
    end
    keys.each.with_index(0) do |item,i|
      if (!"#{className}".constantize.column_names.include? keys[i])
        json = get_json "failed", {}, "can not filter by #{keys[i]}"
      end
    end
    return json
  end

end