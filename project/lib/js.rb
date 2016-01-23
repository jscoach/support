# Simple bridges between Ruby code and JavaScript scripts
module JS
  module ReadMe
    extend self

    # Process a README from GitHub
    # @param `package` must have a name, description and repo
    def execute(html, package)
      raise JsCoach::ArgumentError.new "You must give a hash with package metadata" unless package.is_a? Hash

      File.write tmp_readme_filename, html.force_encoding("utf-8")
      File.write tmp_package_filename, package.to_json

      `node scripts/readmes.js #{ tmp_readme_filename } #{ tmp_package_filename }`
    ensure
      raise "Unable to complete `scripts/readme` successfully." unless $?.success?

      File.delete tmp_readme_filename
      File.delete tmp_package_filename
    end

    def tmp_readme_filename
      @_tmp_readme_filename ||= File.join(Rails.root, "tmp/readme-#{ Process.pid }.html")
    end

    def tmp_package_filename
      @_tmp_package_filename ||= File.join(Rails.root, "tmp/package-#{ Process.pid }.json")
    end
  end

  module Sparkline
    extend self

    def execute(data)
      File.write tmp_data_filename, data.to_json
      `node scripts/sparkline.js #{ tmp_data_filename }`
    ensure
      raise "Unable to complete `scripts/sparkline` successfully." unless $?.success?

      File.delete tmp_data_filename
    end

    def tmp_data_filename
      @_tmp_data_filename ||= File.join(Rails.root, "tmp/data-#{ Process.pid }.json")
    end
  end
end
