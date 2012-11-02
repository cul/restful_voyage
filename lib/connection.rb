module Voyager
  class Connection

    def initialize(config)
      @config = config
    end

    def get_xml(url, patron_homedb = true)
      raise ArgumentError.new('api server url not found') unless @config['api_server']
      full_url = @config['api_server'].strip + url.to_s
      if patron_homedb && !full_url.include?("patron_homedb")
        full_url = full_url + (full_url.include?('?') ? "&" : "?") + "patron_homedb=#{@config['patron_homedb']}"
      end

      puts full_url
      xml = Nokogiri::XML(HTTPClient.get_content(full_url))

      # fix localhost designations
      #
      
      xml.css("*[href^='http://127.0.0.1']").each do |el|
        href_value = el.attributes['href'].value
        el.attributes['href'].value = href_value.gsub("http://127.0.0.1:7014/vxws/", @config['api_server'])
      end

      return xml
      
    end

    def oracle_connection
      raise ArgumentError.new('Oracle configuration not found') unless @config['oracle']
      Voyager::OracleConnection.new(@config['oracle'])
    end
  end
end
