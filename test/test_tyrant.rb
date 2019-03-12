require 'minitest/autorun'
require 'tyrant'

class TestTyrant < Minitest::Test
  def setup
    @tyrant = Tyrant.new 
    @tyrant.open 'localhost', 1978
  end

  def teardown
    @tyrant.clear
    @tyrant.close
  end

  def test_get_retrieves_what_was_put
      @tyrant[:key] = 'value'
      assert_equal 'value', @tyrant[:key]
  end

  def test_raises_connection_refused_error
    assert_raises Errno::ECONNREFUSED do
      Tyrant.open('localhost', 1)
    end
  end

  def test_get_returns_nil_if_key_not_found
    assert_nil @tyrant[:key]
  end

  def test_close_removes_what_was_put
    @tyrant[:key] = 'value'
    @tyrant.clear

    assert_nil @tyrant[:key]
  end

  def test_remove_removes_key
    @tyrant[:key] = 'value'
    @tyrant.remove :key

    assert_nil @tyrant[:key]
  end

  def test_remove_nil_raises_argument_error
    assert_raises ArgumentError do
      @tyrant.remove nil
    end
  end

  def test_remove_missing_key_does_nothing
    @tyrant.remove :key

    assert_nil @tyrant[:key]
  end

  def test_empty_map_size_is_zero
    assert_equal 0, @tyrant.size
  end

  def test_one_element_map_size_is_one
    @tyrant[:key] = 'value'
    assert_equal 1, @tyrant.size 
  end

  def test_iterating_over_empty_map
    @tyrant.each do 
      flunk
    end
  end

  def test_iterating_over_two_element_map
    @tyrant[:key1] = 'value'
    @tyrant[:key2] = 'value'

    count = 0
    @tyrant.each do |key, value|
      count += 1
      assert_equal value, 'value'
    end
    assert_equal 2, count
  end
end
