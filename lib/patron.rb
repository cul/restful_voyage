module Voyager
  class Patron
    attr_reader :connection
 
    attr_reader :patron_id, :uni, :first_name, :last_name, :fine_balance

    def initialize(options = {})
      @connection = options.delete(:connection) || raise(ArgumentError.new("No connection passed."))



      if uni = options.delete(:uni)
        @uni = uni
        @patron_id = @connection.oracle_connection.retrieve_patron_id(@uni)[@uni]
        raise(ArgumentError, "bad uni") if @patron_id.nil?
      end

      patron_id_to_look_up = options.delete(:patron_id) || @patron_id

      raise(ArgumentError, "must supply patron_id or uni") unless patron_id_to_look_up

      nori = @connection.retrieve_hash("patron/#{patron_id_to_look_up}/patronInformation/address", true)
      @first_name = nori['response']['address']['name']['firstName']
      @last_name = nori['response']['address']['name']['lastName']
      @patron_id = patron_id_to_look_up.to_i if @last_name
    end

    def reload_loans!
      @loans = nil
      loans
    end

    def renew_loan(db_key)
      @connection.retrieve_hash("patron/#{patron_id}/circulationActions/loans/#{db_key}", true, :post)
    end
    
    def blocks
      raise "Patron not found" unless self.exists?
      unless @blocks
        nori = @connection.retrieve_hash("patron/#{patron_id}/patronStatus/blocks?view=full")
        blocks = nori['response']['blocks']

        if blocks && blocks
          block_list = blocks['institution']['borrowingBlock']
          @blocks = Array.wrap(block_list).collect { |block| Block.new(connection, block) }


        end

      end

      @blocks

    end

    def request_for_record(record_id)
      raise "Patron not found" unless self.exists?
      noko = @connection.retrieve_xml("record/#{record_id}?view=full&patron=#{patron_id}")

      @request = {}
  
      if noko.css('record')
        element_text = ->(element, css) { sub_el= element.at_css(css); sub_el ? sub_el.text : nil }

        @request['title'] = element_text.(noko, "datafield[tag='245']>subfield[code=a]")
        @request['recall'] = parse_request_for_record(noko.at_css('info[type=Recall]'))
        @request['hold'] = parse_request_for_record(noko.at_css('info[type=HoldRequest]'))

      end

      @request

      
    end

    def holds
      raise "Patron not found" unless self.exists?
      unless @holds
        nori = @connection.retrieve_hash("patron/#{patron_id}/circulationActions/requests/holds?institution=LOCAL&view=full")
        holds = nori['response']['holds']

        if holds
          local = holds['institution']
          @holds = Array.wrap(local['hold']).collect { |hold| Hold.new(connection, hold['requestItem']) }


        end

      end

      @holds

    end


    def fines
      raise "Patron not found" unless self.exists?
      unless @fines
        nori = @connection.retrieve_hash("patron/#{patron_id}/circulationActions/debt/fines?view=full&institution=LOCAL")
        fines = nori['response']['fines']

        if fines
          local = fines['institution']
          @fine_balance = local['balance']['finesum']
          @fines = Array.wrap(local['fine']).collect { |fine| Fine.new(connection, fine) }


        end

      end

      @fines

    end

    def loans
      raise "Patron not found" unless self.exists?

      unless @loans 
        nori = @connection.retrieve_hash("patron/#{patron_id}/circulationActions/loans?view=full")
        
        @loans = nori['response']['loans']['institution']['loan'].collect { |loan| Loan.new(@connection, loan) }

      end

      @loans
    end

    def exists?
      !@patron_id.nil?
    end

    private

    def parse_request_for_record(xml)
      element_text = ->(element, css) { sub_el= element.at_css(css); sub_el ? sub_el.text : nil }
      element_attr = ->(element, name) { (attr = element.attributes[name]; attr ? attr.value : nil) }
      element_css_attr = ->(element, css, name) { sub_el = element.at_css(css); sub_el ? (attr = sub_el.attributes[name]; attr ? attr.value : nil) : nil }

      if xml && ((element_css_attr.(xml, "recall", "allowed") == "Y") || (element_css_attr.(xml, "hold", "allowed") == "Y"))
        result = {}

        result['dbkey'] = element_css_attr.(xml,'dbkey', 'code')

        result['pickup_locations'] = xml.css('pickup-location').collect do |loc|
          {code: element_attr.(loc,'code'), name: loc.text, default: element_attr.(loc,'default')}
        end

        result['items'] = xml.css('items>item').collect do |item|
          {item_id: element_text.(item, 'item_id'), description: element_text.(item, 'description')}
        end

        result
      else
        nil
      end
    end
  end
end
