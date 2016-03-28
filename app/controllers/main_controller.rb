class MainController < ApplicationController
  require 'json'

  $STATUS_REC = "RECORDING"
  $STATUS_EDIT = "EDITING"

  def getJson(status, data, msg)
  	return {"status" => status, "data" => data, "msg" => msg}
  end

  def test
  	
  end

end

	

