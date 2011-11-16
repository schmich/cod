module Cod
  class SimpleSerializer
    def en(obj)
      Marshal.dump(obj)
    end
    
    def de(io)
      if block_given?
        Marshal.load(io, Proc.new)
      else
        Marshal.load(io)
      end
    end
  end
end