require 'socket'
require 'tyrant_socket'

class Tyrant
  include Enumerable

  attr_reader :socket

  def []=(key, value)
    socket.write_operation Operation::PUT
    socket.write_key_value key, value

    status = socket.read_byte
    raise IOError if status != 0
  end

  def [](key)
    socket.write_operation Operation::GET
    socket.write_key key

    status = socket.read_byte
    return nil if status == 1
    raise IOError if status != 0

    length = socket.read_int
    socket.read(length)
  end

  def clear
    socket.write_operation Operation::VANISH

    status = socket.read_byte
    raise IOError if status != 0
  end

  def remove(key)
    raise ArgumentError if key == nil
    socket.write_operation Operation::REMOVE
    socket.write_key key

    status = socket.read_byte
    return if status == 1
    raise IOError if status != 0
  end

  def size
    socket.write_operation Operation::SIZE

    status = socket.read_byte
    raise IOError if status != 0

    socket.read_long
  end

  def each
    reset_iterator

    key = next_key
    while key != nil do
      yield key, self[key]
      key = next_key
    end
  end

  def open(host, port)
    @socket ||= TCPSocket.open host, port
    socket.extend TyrantSocket
  end

  def close
    socket.close
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

  private
    def reset_iterator
      socket.write_operation Operation::RESET_ITERATOR

      status = socket.read_byte
      raise IOError if status != 0
    end

    def next_key
      socket.write_operation Operation::GET_NEXT_KEY

      status = socket.read_byte
      return nil if status == 1
      raise IOError if status != 0

      length = socket.read_int
      socket.read(length)
    end
end

module Tyrant::Operation
  PREFIX = 0xC8
  PUT = 0x10
  GET = 0x30
  VANISH = 0x72
  REMOVE = 0x20
  SIZE = 0x80
  RESET_ITERATOR = 0x50
  GET_NEXT_KEY = 0x51
end
