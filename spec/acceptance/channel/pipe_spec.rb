require 'spec_helper'

describe Cod::Channel::Pipe do
  context "anonymous pipes" do
    let!(:pipe) { Cod.pipe }
    after(:each) { pipe.close }
    
    it "have simple message semantics" do
      # Split the channel into a write end and a read end. Otherwise
      # reading / writing from the channel will close the other end, 
      # leaving us unable to perform all operations.
      read = pipe
      write = pipe.dup
      
      write.put 'message1'
      write.put 'message2'

      read.should be_waiting
      read.get.should == 'message1'
      read.should be_waiting
      read.get.should == 'message2'
      
      read.should_not be_waiting
    end 
    it "don't allow write after read" do
      # Put to a duplicate, so that the test does what it says.
      pipe.dup.put 'foo'
      
      pipe.get
      
      lambda {
        pipe.put 'test'
      }.should raise_error(Cod::Channel::DirectionError)
    end
    it "don't allow read after write" do
      
      lambda {
        pipe.put 'test'
        pipe.get
      }.should raise_error(Cod::Channel::DirectionError)
    end  
    it "should work after a fork" do
      child_pid = fork do
        pipe.put 'test'
        pipe.put Process.pid
      end
      
      begin
        pipe.get.should == 'test'
        pipe.get.should == child_pid
      ensure
        Process.wait(child_pid)
      end
    end 
    it "should also transfer objects" do
      read, write = pipe, pipe.dup
      
      write.put 1
      write.put true
      write.put :symbol
      
      read.get.should == 1
      read.get.should == true
      read.get.should == :symbol
    end 
    it "should error out in an EOF situation" do
      a = pipe.dup
      b = pipe.dup
      
      a.put 'test'
      b.put 'test'
      pipe.get
      
      # Should not error out early, b still isn't EOF
      a.close
      b.close
    
      # We're now in EOF situation, but still have waiting messages
      pipe.should be_waiting

      pipe.get
      
      pipe.should_not be_waiting

      # Now we're EOF:
      expect {
        pipe.get
      }.to raise_error(Cod::Channel::CommunicationError)
    end 
    it "allow for simple disconnected messaging semantics" do
      # An identifier is something we can also send over the wire!
      identifier = pipe.identifier
      
      duplicate = Cod.create_reference(identifier).dup
      
      pipe.put :something
      duplicate.get.should == :something
    end 
    it "are garbage collected once no one holds a reference" 
  end
end