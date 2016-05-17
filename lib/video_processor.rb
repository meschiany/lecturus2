require 'streamio-ffmpeg'

class VideoProcessor

 def get_log_id
    "[#{self.class.name}][#{Thread.current.object_id.to_s(36)}]"
  end

  def initialize(file)
    @file = file
  end
  
  def concat file2 ,output_file=Tempfile.new(['video','.mp4'])
    options = {custom: "-c copy output.mp4"}
    movie.transcode(output_file.path ,options)
    output_file
  end

  def thumbnail second: nil, output_file: Tempfile.new(['screenshot','.jpg'])
    Rails.logger.debug {"#{get_log_id} capturing screenshot thumbnail "}
    second = 0 if second.nil?
    movie.screenshot(output_file.path, :seek_time => second)
    output_file
  end

  def trim segment:, output_file: Tempfile.new(['movie','.mp4']), resolution: nil
    Rails.logger.debug {"#{get_log_id} --<8 trimming: "}
    options = {custom: "-ss #{segment.first} -to #{segment.last} -async 1 -strict -2 -an"}
    options[:resolution] = resolution if resolution
    movie.transcode(output_file.path, options)
    output_file
  end

  def encode output_file: Tempfile.new(['movie','.mp4']), resolution: nil
    Rails.logger.debug {"encoding video to #{output_file.path.split('.').last}"}
    options = {}
    options[:resolution] = resolution if resolution
    movie.transcode(output_file.path, options)
    output_file
  end

  private

  def movie
    @movie ||= FFMPEG::Movie.new(@file.path)
  end

end