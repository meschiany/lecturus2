class MainController < ApplicationController
  require 'json'


  $STATUS_REC = "RECORDING"
  def getJson(status, data, msg)
  	return {"status" => status, "data" => data, "msg" => msg}
  end

 #  def save_file
	# 	data_url = params[:imgBase64]
	# 	puts data_url
	# 	name = params[:name]
	# 	png = Base64.decode64(data_url['data:image/png;base64,'.length .. -1])
	# 	File.open(Rails.root.join('app/assets/uploads/'+name+'.png'), 'wb') { |f| f.write(png) }
	# 	head :ok
	# end


	 # (‘img - 1’,’file - 2’,’txt - 0’)



end

	

