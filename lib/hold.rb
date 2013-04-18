module Voyager
  class Hold
    attr_reader :connection

    attr_reader :item_id, :hold_recall_id, :reply_note, :status, :status_text, :hold_type, :item_title, :expired_date, :db_key, :db_name, :queue_position, :pickup_location, :pickup_location_code

    def initialize(connection, hash)
      @item_id = hash['itemId']
      @hold_recall_id = hash['holdRecallId']
      @reply_note = hash['replyNote']
      @status = hash['status']
      @status_text = hash['statusText']
      @hold_type = hash['holdType']
      @item_title = hash['itemTitle']
      @expired_date = hash['expiredDate']
      @db_key = hash['dbKey']
      @db_name = hash['dbName']
      @queue_position = hash['queuePosition']
      @pickup_location = hash['pickupLocation']
      @pickup_location_code = hash['pickupLocationCode']
    end


  end
end
