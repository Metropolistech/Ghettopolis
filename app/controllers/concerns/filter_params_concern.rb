module FilterParamsConcern
  extend ActiveSupport::Concern

  def rename_params(key: nil, to: nil)
    required_params.to_h.rename_key(key, to)
  end
end
