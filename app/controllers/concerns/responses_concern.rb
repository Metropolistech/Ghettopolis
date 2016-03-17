module ResponsesConcern

  extend ActiveSupport::Concern

  require 'yaml'
  @@responses = YAML.load(File.read(Rails.root.join('lib/yml', 'server_responses.yml')))

  def res_send(data: {}, status: 200, error: false)
    # If it's an error and status is default 200, force status to 400
    if status == 200 and error == true then status = 400 end

    return send_status_res(status) if data.blank?

    error ? send_err(data, status) : send_res(data, status)
  end

  private

  def send_status_res(status)
     render json: { status: status, message: status_message(status) }, status: status
  end

  def send_err(data, status)
      render json: { status: status, error: true, errors: sanitize_errors(data: data) }, status: status
  end

  def send_res(data, status)
    render json: { status: status, data: data }, status: status
  end

  # ([{type: message}, ...]) => { type: message, ...}
  def sanitize_errors(data: [])
    data.inject({}) do |errors, err|
      if err.kind_of?(Array)
        errors[err.first] = err.last.first
      else
        errors[err.keys.first] = err.values.first
      end
      errors
    end
  end

  def status_message(status)
      @@responses["responses"][status]["message"]
    rescue
      nil
  end
end
