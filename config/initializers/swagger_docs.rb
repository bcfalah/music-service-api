class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.base_api_controller = Api::V1::ApiController

Swagger::Docs::Config.register_apis({
  "1.0" => {
    controller_base_path: '',
    api_file_path: 'public/apidocs',
    # base path url of our application
    # while using production mode, point it to production url
    :base_path => "http://localhost:3000",
    # setting this option true tells swagger to clean all files generated in api_file_path directory before any files are generated
    :clean_directory => true,
    # As we are using Rails-API, our ApplicationController inherits ActionController::API instead of ActionController::Base
    # Hence, we need to add ActionController::API instead of default ActionController::Base
    parent_controller: Api::V1::ApiController,
    # parent_controller needs to be specified if API controllers are inheriting some other controller than ApplicationController
    # :parent_controller => ApplicationController,
    :attributes => {
      :info => {
        "title" => "Music Service API Documentation",
        "description" => "Interactive documentation for Music Service API",
        "contact" => "",
        "license" => "Apache 2.0",
        "licenseUrl" => "http://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }
  }
})
