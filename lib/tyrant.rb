require 'socket'

class Tyrant
  module Operation
    PREFIX = 0xC8
    PUT = 0x10
    GET = 0x30
  end

  attr_reader :socket

  def []=(key, value)
    socket.write [Operation::PREFIX, Operation::PUT].pack('C*')
    socket.write [key.length].pack('L>')
    socket.write [value.length].pack('L>')
    socket.write key
    socket.write value

    status, = socket.read(1).unpack('C')
    raise IOError if status != 0
  end

  def [](key)
    socket.write [Operation::PREFIX, Operation::GET].pack('C*')
    socket.write [key.length].pack('L>')
    socket.write key

    status, = socket.read(1).unpack('C')
    raise IOError if status != 0

    length, = socket.read(4).unpack('L>')
    socket.read(length)
  end

  def open(host, port)
    @socket ||= TCPSocket.open host, port
  end

  def close
    @socket.close
  end

  def self.open(host, port)
    t = self.new
    t.open(host, port)
    begin
      yield t
    ensure
      t.close
    end
  end
end
