require 'cod/channel/tcp'

module Cod
  # A channel based on a tcp connection.
  #
  class Channel::TCPConnection < Channel::Base
    include Channel::TCP
    
    def initialize(destination)
      not_implemented
    end
    
    def initialize_copy(from)
      not_implemented
    end
    
    def put(message)
      not_implemented
    end
    
    def get(opts={})
      not_implemented
    end
    
    def waiting?
      not_implemented
    end
    
    def close
      not_implemented
    end
    
    def identifier
      not_implemented
    end
  end
end