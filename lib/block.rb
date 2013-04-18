module Voyager
  class Block
    attr_reader :connection

    attr_reader :block_reason, :block_count, :block_code, :block_limit, :item_type, :patron_group_name 

    def initialize(connection, hash)
      @block_reason = hash['blockReason']
      @block_count = hash['blockCount']
      @block_limit = hash['blockLimit']
      @item_type = hash['itemType']
      @patron_group_name = hash['patronGroupName']

    end


  end
end
