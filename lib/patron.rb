module Voyager
  class Patron
    attr_reader :connection
 
    attr_reader :patron_id, :uni

    def initialize(options = {})
      @connection = options.delete(:connection) || raise(ArgumentError.new("No connection passed."))



      if uni = options.delete(:uni)
        @uni = uni
        @patron_id = @connection.oracle_connection.retrieve_patron_id(@uni)[@uni]

      elsif (patron_id = options.delete(:patron_id))
        xml = @connection.get_xml("patron/#{patron_id}")
        if xml.at_css('reply-text').text == "ok"
          @patron_id = patron_id.to_i
        end
      else
        raise ArgumentError.new("Must specify patron_id or uni")
      end
    end

    def loans
      raise "Patron not found" unless self.exists?

      unless @loans 
        xml = @connection.get_xml("patron/#{patron_id}/circulationActions/loans?view=full")
        
        @loans = xml.css('loan').collect { |xml_node| Loan.new(@connection, xml_node) }

      end

      @loans
    end

    def exists?
      !@patron_id.nil?
    end
  end
end
