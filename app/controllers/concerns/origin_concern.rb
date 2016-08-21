module OriginConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_origin
  end

  protected

  def check_origin
    if Rails.env.production? && production_origin?
      return res_send status: 401, data: { message: 'Unauthorized' }
    end
  end

  private

  def production_origin?
    request.headers['Origin'] != ENV['PRODUCTION_ORIGIN']
  end
end
