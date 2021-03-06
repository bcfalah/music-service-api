module RequestHelper
  # Parse JSON response to ruby hash
  def json_response
    JSON.parse(response.body)
  end

  def json_response_hash
    json_response.with_indifferent_access
  end

  def api_get action, params={}, version="1"
    get "/api/v#{version}/#{action}", params
  end

  def api_post action, params={}, version="1"
    post "/api/v#{version}/#{action}", params
  end

  def api_delete action, params={}, version="1"
    delete "/api/v#{version}/#{action}", params
  end

  def api_put action, params={}, version="1"
    put "/api/v#{version}/#{action}", params
  end
end
