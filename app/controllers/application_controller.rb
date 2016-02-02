class ApplicationController < Api::V1::BaseController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  require 'yaml'
  @@responses = YAML.load(File.read(Rails.root.join('lib/yml', 'server_responses.yml')))

  def res_send(data: {}, status: 200, error: false)
    if data.blank?
      return send_status_res(status)
    else
      return error ? send_err(data, status) : send_res(data, status)
    end
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
