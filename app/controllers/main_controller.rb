class MainController < ApplicationController
  require 'json'

  $STATUS_REC = "RECORDING"
  $STATUS_EDIT = "EDITING"

  def getJson(status, data, msg)
  	return {"status" => status, "data" => data, "msg" => msg}
  end

  def test
  	
  end

  def validateParams(params,param_to_check)
    param_to_check.each do |k, v|
      data = params[k]
      if !data || !data == "" || data.nil?
        return getJson("failed", params, "missing "+k)
      end
    end
    return nil
  end

end

	

