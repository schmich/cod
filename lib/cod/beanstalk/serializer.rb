class Cod::Beanstalk
  # This is a kind of beanstalk message middleware: It generates and parses
  # beanstalk messages from a ruby format into raw bytes. The raw bytes go
  # directly into the tcp channel that underlies the beanstalk channel. 
  #
  # Messages are represented as simple Ruby arrays, specifying first the
  # beanstalkd command, then arguments. Examples: 
  #   [:use, 'a_tube']
  #   [:delete, 123]
  #
  # One exception: The commands that have a body attached will be described
  # like so in protocol.txt: 
  #   put <pri> <delay> <ttr> <bytes>\r\n
  #   <data>\r\n
  #
  # To generate this message, just put the data where the bytes would be and
  # the serializer will do the right thing. 
  #   [:put, pri, delay, ttr, "my_small_data"]
  #
  # Results come back in the same way, except that the answers take the place
  # of the commands. Answers are always in upper case.
  #
  # Also see https://raw.github.com/kr/beanstalkd/master/doc/protocol.txt.
  #
  class Serializer
    
  end
end