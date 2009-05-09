require 'thread'
require 'timeout'

class NonBlockingSizedQueue < SizedQueue
  DEFAULT_TIMEOUT = 1
  
  def initialize(max, should_block_on_push = false)
    super(max)
    @should_block_on_push = should_block_on_push
  end
  
  def push(obj)
    @should_block_on_push ? super(obj) : push_with_timeout { super(obj) }
  end
  
  alias :enq :push
  alias :<< :push
  
  private 
  def push_with_timeout
    begin
      Timeout::timeout(DEFAULT_TIMEOUT) do
        yield
      end
    rescue Timeout::Error
    end
  end
end
