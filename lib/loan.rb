module Voyager
  class Loan
    attr_reader :connection

    attr_reader :item_id, :item_type, :barcode, :due_date, :title, :status_code, :status_text, :can_renew
    def initialize(connection, xml)
      element_text = ->(element, css) { sub_el= element.at_css(css); sub_el ? sub_el.text : nil }
      element_attr = ->(element, name) { attr = element.attributes[name]; attr ? attr.value : nil }
      @can_renew = element_attr.(xml, 'canRenew') == "Y"
      @title = element_text.(xml, 'title')
      @item_id = element_text.(xml, 'itemId')
      @item_type = element_text.(xml, 'itemtype')
      @barcode = element_text.(xml, 'itemBarcode')
      @due_date = DateTime.parse(element_text.(xml, 'dueDate'))
      @status_code = element_text.(xml, 'statusCode')
      @status_text = element_text.(xml, 'statusText')

    end
  end
end
