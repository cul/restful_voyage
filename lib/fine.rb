module Voyager
  class Fine
    attr_reader :connection

    attr_reader :fine_id, :fine_date, :item_title, :fine_type, :amount, :db_key, :db_name

    def initialize(connection, hash)
      @fine_id = hash['fineId']
      @fine_date = hash['fineDate']
      @item_title = hash['itemTitle']
      @fine_type = hash['fineType']
      @amount = hash['amount']
      @db_key = hash['dbKey']
      @db_name = hash['dbName']
    end


  end
end
