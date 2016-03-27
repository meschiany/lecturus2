class MainController < ApplicationController
  require 'json'

  $STATUS_REC = "RECORDING"

  def getJson(status, data, msg)
  	return {"status" => status, "data" => data, "msg" => msg}
  end

end

	

