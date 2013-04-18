require 'helper'
require 'minitest/autorun'

class TestPatron < MiniTest::Unit::TestCase
  def test_uni_to_patron

    patron = Patron.new(uni: 'jws2135', connection: default_connection)
    assert patron.exists?
    assert_equal 8547912, patron.patron_id
  end

  def test_bad_uni
    assert_raises ArgumentError do
      patron = Patron.new(uni: 'xxxx215x', connection: default_connection)
    end
    
  end

  def test_needs_connection
    assert_raises ArgumentError do
      Patron.new(uni: 'jws2135')
    end
  end


  def test_bad_patron_id
    patron = Patron.new(patron_id: 'zx780z8xc098xc0', connection: default_connection)
    assert !patron.exists?
  end

  def test_loans

    patron = Patron.new(uni: 'jws2135', connection: default_connection)
    assert patron.loans.length > 1

  end

  def test_fines
    patron = Patron.new(uni: 'kea6', connection: default_connection)
    assert patron.fines.length > 0

  end

end
