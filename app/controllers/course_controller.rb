class CourseController < MainController

	def new
		localParams = ["college_id", "name", "professor", "year", "semester"]
		result = set_new "#{params['controller']}".camelize, localParams
		render result
	end

	def get_all_with_videos

		return if authenticate_user.nil?

  		user = get_user_by_token
  		courses = Course.where("college_id=#{user['college_id']}")
  		videos = []
  		courses.each_with_index do |course, i|
			course.videos.each do |video|
				if video.status == "PUBLISHED"
	 	   			videos.push(video)
				end
			end
		end
		data = {:courses => courses, :videos => videos}
		json = get_json "success", data, "get_all_with_videos"
    	result = {:json => json, :status => :ok}

  		render result
	end
end