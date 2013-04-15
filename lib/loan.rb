module Voyager
  class Loan
    attr_reader :connection

    attr_reader :patron, :item_id, :item_type, :barcode, :due_date, :title, :status_code, :status_text, :can_renew, :db_key
    def initialize(connection, hash)
      @can_renew = (hash['@canRenew'] == "Y")
      @title = hash['title']
      @item_id = hash['itemId']
      @item_type = hash['itemtype']
      @barcode = hash['itemBarcode']
      @due_date = DateTime.parse(hash['dueDate'])
      @status_code = hash['statusCode']
      @status_text = hash['statusText']
      @db_key = hash['dbKey']

    end


  end
end
