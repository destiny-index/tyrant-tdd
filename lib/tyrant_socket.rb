module TyrantSocket
  def write_int(value)
    write [value].pack('L>')
  end

  def read_byte
    byte, = read(1).unpack('C')
    byte
  end

  def read_int
    int, = read(4).unpack('L>')
    int
  end

  def read_long
    long, = read(8).unpack('Q>')
    long
  end

  def write_key(key)
    write_int key.length
    write key
  end

  def write_key_value(key, value)
    write_int key.length
    write_int value.length
    write key
    write value
  end

  def write_operation(operation)
    write [Tyrant::Operation::PREFIX, operation].pack('C*')
  end
end
