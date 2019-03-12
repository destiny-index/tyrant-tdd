require 'minitest/autorun'
require 'tyrant'

class TestTyrant < Minitest::Test
  def test_get_retrieves_what_was_put
    Tyrant.open('localhost', 1978) do |t|
      t[:key] = 'value'
      assert_equal 'value', t[:key]
    end
  end

  def test_raises_connection_refused_error
    assert_raises Errno::ECONNREFUSED do
      Tyrant.open('localhost', 1)
    end
  end
end
