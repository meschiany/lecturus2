class MainController < ApplicationController
  require 'json'

  $STATUS_REC = "RECORDING"
  $STATUS_EDIT = "EDITING"

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

  def validateFilters(params, className)
    json = nil
    keys = params["filters"].keys
    keys.each.with_index(0) do |item,i|
      if (!"#{className}".constantize.column_names.include? keys[i])
        json = _getJson("failed", {}, "can not filter by #{keys[i]}")
      end
    end
    return json
  end

  def _isTokenValid(params)
    if !params["token"] || params["token"] == "" || params["token"].nil?
      return false
    end
    user = User.where("token='#{params['token']}'")
    if user.size<=0
      return false
    end
    return true
  end

  def show
    if _isTokenValid(params)
      vid = "#{params['controller']}".camelize.constantize.find_by_id(params[:id])
      if vid
        json = _getJson("success", vid, "show")
        result = {:json => json, :status => :ok}
      else
        json = {"msg"=>"not found"}
        result = {:json => {"msg"=>"not found"}, :status => :not_found}
      end
    else
      json = _getJson("failed", {}, "No valid token was sent")
      result = {:json => json, :status => :not_found}
    end
    render result
  end

  def _getData(className, params)
    if params.length <= 2
      posts = "#{className}".constantize.all
      json = _getJson("success", posts, "get all")
    else
      json = validateFilters(params,"Post")
      if json.nil?
        keys = params["filters"].keys
        values = params["filters"].values
        query = ""
        if (keys.length)
          query = query + "#{keys[0]}= #{values[0]}"
          if (keys.length > 1)
            keys[1..-1].each.with_index(1) do |item,i|
              query = query + " AND #{keys[i]}= #{values[i]}"
            end 
          end
        end
        posts = "#{className}".constantize.where(query)
        json = _getJson("success", posts, "get by "+keys[0]+"="+values[0])
      end
    end
    return json
  end

  def setNew(className, params, localParams)
    if _isTokenValid(params)
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
    else
      json = _getJson("failed", {}, "No valid token was sent")
      result = {:json => json, :status => :not_found}
    end
    return result
  end

  def get
    if _isTokenValid(params)
      json = _getData("#{params['controller']}".camelize, params)
      result = {:json => json, :status => :ok}      
    else
      json = _getJson("failed", {}, "No valid token was sent")
      result = {:json => json, :status => :not_found}
    end
    render result
  end


end

	

