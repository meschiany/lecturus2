S3_CONFIG = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env]

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => S3_CONFIG['aws_access_key_id'],     # required
    :aws_secret_access_key  => S3_CONFIG['aws_secret_access_key'], # required
    :region                 => 'us-east-1',
    #:host                   => 'http://s3.amazonaws.com'      # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = S3_CONFIG['bucket']                    # required
  config.fog_public     = true                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  config.asset_host = S3_CONFIG['asset_host']
end