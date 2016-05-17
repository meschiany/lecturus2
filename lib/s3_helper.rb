require 'httparty'

class S3Helper

  class << self

    def exist?(file_name)
      url = s3_url + "#{file_name}"
      response = HTTParty.get(url)
      response.code.to_s == '200'
    end

    def get_file(file_name)
      url = s3_url + "#{file_name}"
      thumbnail_file = Tempfile.new(['thumbnail','.jpg'])
      thumbnail_file.binmode # note that the tempfile must be in binary mode
      thumbnail_file.write open(url).read
      thumbnail_file.rewind
      thumbnail_file
    end

    private

    def s3_url
      s3_url = 'http://s3.amazonaws.com/lecturus/videos/'
    end

  end

end