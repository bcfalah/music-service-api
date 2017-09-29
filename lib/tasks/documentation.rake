namespace :documentation do
  desc 'Loads sample data. Intended just for development usage.'
  task generate: :environment do
    Rake::Task["swagger:docs"].invoke
    docs_root_filename = 'public/apidocs/api-docs.json'
    docs_root_file = File.read(docs_root_filename)
    data_hash = JSON.parse(docs_root_file)
    data_hash['basePath'] = "/"
    File.open(docs_root_filename, 'w') do |f|            
      f.puts data_hash.to_json
    end
  end
end
