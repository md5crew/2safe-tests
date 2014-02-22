require 'json'
require 'socket'
require 'test/unit'

SOCKET_PATH = File.join(Dir.home, '.2safe', 'control.sock')

class TestDaemon < Test::Unit::TestCase
  def setup
    socket = UNIXSocket.new SOCKET_PATH
    socket.puts '{"type":"set_settings","args":{"login":"foo","email":"bar"}}'
  end

  def test_settings
    socket = UNIXSocket.new SOCKET_PATH
    socket.puts '{"type":"get_settings","fields":["email","login"]}'
    data = String.new
    while line = socket.gets
      data += line
    end
    json = JSON.parse data
    assert_equal(json['type'], 'settings')
    assert_equal(json['values']['login'], 'foo')
    assert_equal(json['values']['email'], 'bar')
  end
end