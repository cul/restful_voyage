require 'helper'
require 'minitest/autorun'

class TestPatron < MiniTest::Unit::TestCase
  def test_uni_to_patron
    patron = Patron.new(uni: 'gb8', connection: default_connection)
    assert patron.exists?
    assert_equal 29841, patron.patron_id

    patron = Patron.new(uni: 'jws2135', connection: default_connection)
    assert patron.exists?
    assert_equal 8547912, patron.patron_id
  end

  def test_bad_uni
    patron = Patron.new(uni: 'xxxx215x', connection: default_connection)
    assert !patron.exists?
    
  end

  def test_needs_connection
    assert_raises ArgumentError do
      Patron.new(uni: 'jws2135')
    end
  end

  def test_load_with_patron_id
    assert_raises ArgumentError do
      Patron.new(connection: default_connection)
    end

    patron = Patron.new(patron_id: '29841', connection: default_connection)
    assert patron.exists?
    assert_equal patron.patron_id, 29841
  end

  def test_bad_patron_id
    patron = Patron.new(patron_id: 'zx780z8xc098xc0', connection: default_connection)
    assert !patron.exists?
  end

  def test_loans

    patron = Patron.new(uni: 'gb8', connection: default_connection)
    assert_equal 2, patron.loans.length
    raise patron.loans.first.inspect

  end
end
