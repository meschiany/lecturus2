class MainController < ApplicationController
  require 'json'
  after_filter :set_access_control_headers

  $STATUS_REC = "RECORDING"
  $STATUS_EDIT = "EDITING"

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def test
  end

  def _getJson(status, data, msg)
  	return {"status" => status, "data" => data, "msg" => msg}
  end

  def validateParams(params, param_to_check)
    param_to_check.each do |k, v|
      data = params[k]
      if !data || !data == "" || data.nil?
        return _getJson("failed", params, "missing "+k)
      end
    end
    return nil
  end

  def validateFilters(params, className, get_all)
    json = nil
    if get_all
      keys=[]
    else
      keys = params["filters"].keys
    end
    keys.each.with_index(0) do |item,i|
      if (!"#{className}".constantize.column_names.include? keys[i])
        json = _getJson("failed", {}, "can not filter by #{keys[i]}")
      end
    end
    return json
  end

  def _isSessionTimeValid(user)
    if (user['last_login_timestamp'].to_i)+86400 < Time.now.to_i
      result = {"bool" => false, "msg" => "session timed out"}
      user.update_attribute(:token, "")
    else
      result = {"bool" => true, "msg" => "valid"}
    end
    return result 
  end

  def _isTokenValid(params)
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
        result = _isSessionTimeValid(user[0])
      end
    end
    return result
  end

  def _getUserByToken(params)
    if params["debug"] == "true"
      user = User.first
    else
      user = User.where("token='#{params["token"]}'").first
    end
    if user.nil?
      return nil
    end
    return user
  end

  def show()
    tokenValid = _isTokenValid(params)
    if tokenValid["bool"]
      vid = "#{params['controller']}".camelize.constantize.find_by_id(params[:id])
      if vid
        json = _getJson("success", vid, "show")
        result = {:json => json, :status => :ok}
      else
        result = {:json => {"msg"=>"not found"}, :status => :not_found}
      end
    else
      json = _getJson("failed", {}, tokenValid["msg"])
      result = {:json => json, :status => :not_found}
    end
    render result
  end

  def _getData(className, params)
    if params.length <= 2
      posts = "#{className}".constantize.all
      json = _getJson("success", posts, "get all")
      return json
    end

    get_all = false
    if params["filters"].nil?
      get_all = true
    end

    json = validateFilters(params,"#{className}".constantize, get_all)
    if !json.nil?
      return json
    end

    keys = []
    values = []
    if !get_all
      keys = params["filters"].keys
      values = params["filters"].values
    end

    b = "#{params['filters'].map { |k, v| "#{k}='#{v}'" }.join(' AND ')}"
    if get_all 
      posts = "#{className}".constantize.all
      str = "get all"
    else
      posts = "#{className}".constantize.where(b)
      str = "get by "+keys[0]+"="+values[0].to_s
    end
    json = _getJson("success", posts, str)
  
    return json
  end


# TODO rearange the order by name and not by location
  def setNew(className, params, localParams, should_validate=true)
    tokenValid = _isTokenValid(params)
    if (tokenValid['bool'] || !should_validate)
      json = validateParams(params,localParams)
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
        json = _getJson("success", record, "saved")
        result = {:json => json, :status => :ok}
      else
        result = {:json => json, :status => :not_found}
      end
    else
      json = _getJson("failed", {}, tokenValid['msg'])
      result = {:json => json, :status => :not_found}
    end
    return result
  end

  def get()
    tokenValid = _isTokenValid(params)
    if tokenValid['bool']
      json = _getData("#{params['controller']}".camelize, params)
      puts json
      result = {:json => json, :status => :ok}      
    else
      json = _getJson("failed", {}, tokenValid['msg'])
      result = {:json => json, :status => :not_found}
    end
    render result
  end

  def ffmpeg
    @path ||= File.expand_path(`which melt`)
    video1 = S3Helper.get_file(name)
    # video2 = S3Helper.get_file(name)
    outputfile = VideoProcessor.new("concat:61.mp4|61.mp4")
    VideoUploader.new.upload_video_to_s3(outputfile, 'out1.mp4')
  end
end