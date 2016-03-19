module S3ImagesConcern
  extend ActiveSupport::Concern

  @@image_regex = %r{^data:(.*?);(.*?),(.*)$}
  @@dest_folder = "uploads"

  def convert_data_uri_to_upload(obj_hash)
	  if obj_hash[:image_url].try(:match, @@image_regex)
      self
        .decode_image_data(obj_hash: obj_hash)
        .create_temporary_file
        .upload_file
		else
      nil
    end
  end

  def decode_image_data(obj_hash: {})
    @image_data = split_image_data(obj_hash[:image_url])
    image_encoded_string = @image_data[:encoded]
    @image_data_binary = Base64.decode64(image_encoded_string)
    self
  end

  def create_temporary_file
    @temp_img_file = Tempfile.new(SecureRandom.hex).binmode
    @temp_img_file << @image_data_binary
    @temp_img_file.rewind
    self
  end

  def upload_file
    s3_file = S3_BUCKET
      .put_object({
        acl: "public-read",
        body: @temp_img_file,
        key: get_filename
      })
    s3_file.public_url.to_s
  end

  def split_image_data(uri_str)
	  if uri_str.match(@@image_regex)
	    uri = Hash.new
	    uri[:type] = $1
	    uri[:encoder] = $2
	    uri[:encoded] = $3
	    uri[:extension] = $1.split('/')[1]
	    return uri
	  else
	    return nil
	  end
  end

  private
    def get_filename
       @filename = "#{@@dest_folder}/#{SecureRandom.hex}.#{@image_data[:extension]}"
    end
end
