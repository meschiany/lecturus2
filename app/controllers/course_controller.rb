class CourseController < MainController

	def new
		localParams = ["college_id", "name", "professor", "year", "semester"]
		result = setNew("#{params['controller']}".camelize, params, localParams)
		render result
	end

	def getAllWithVideos
    	tokenValid = _isTokenValid(params)
    	if tokenValid['bool']
    		user = _getUserByToken(params)
    		courses = Course.where("college_id=#{user['college_id']}")
    		videos = []
    		courses.each_with_index do |course, i|
    			course.videos.each do |video|
    				# if video.status == "PUBLISHED"
    				if video.status == "PUBLISHED"
   						videos.push(video)
   					end
   				end
			end
			data = {:courses => courses, :videos => videos}
			json = _getJson("success", data, "getAllWithVideos")
      		result = {:json => json, :status => :ok}
    	else
      		json = _getJson("failed", {}, tokenValid['msg'])
      		result = {:json => json, :status => :not_found}
    	end
    	render result
	end

end