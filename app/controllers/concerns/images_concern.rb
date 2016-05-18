module ImagesConcern
  extend ActiveSupport::Concern
  include S3ImagesConcern

  def save_image_to_s3_and_db(params_h)
    hash = filter_params(params_h)
    img = upload_file_before_save(hash)
    save_image_to_db(img)
  end

  def filter_params params
    params.inject({}) do |hash,(k,v)|
      hash[k.to_sym] = v if k == "image_data"
      hash
    end
  end

  def upload_file_before_save hash
    upload_to_S3(hash)
  end

  def save_image_to_db(image)
    Image.create(image_name: image)
  end
end
