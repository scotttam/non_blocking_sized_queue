require 'test/unit'
require '../non_blocking_sized_queue'

class TestNonBlockingSizedQueue < Test::Unit::TestCase

  def setup
    @queue_length = 5
  end

  def test_push_should_timeout_if_set_and_not_raise_exception
    queue = NonBlockingSizedQueue.new(@queue_length)

    assert_equal queue.length, 0
    
    assert_nothing_raised do
      thread = Thread.new {(@queue_length*2).times { queue.push(:something) }}
      thread.join
    end
    
    assert_equal @queue_length, queue.length
  end
  
  def test_push_should_block_if_not_set_and_raises_thread_error_sleep_forever
    queue = NonBlockingSizedQueue.new(@queue_length, should_block_on_timeout = true)

    assert_equal queue.length, 0
    
    assert_raises ThreadError do
      (@queue_length*2).times { queue.push(:something) }
    end
  end

  def test_enq_should_timeout_if_set_and_not_raise_exception
    queue = NonBlockingSizedQueue.new(@queue_length)

    assert_equal queue.length, 0
    
    assert_nothing_raised do
      thread = Thread.new {(@queue_length*2).times { queue.enq(:something) }}
      thread.join
    end
    
    assert_equal @queue_length, queue.length
  end
  
  def test_enq_should_block_if_not_set_and_raises_thread_error_sleep_forever
    queue = NonBlockingSizedQueue.new(@queue_length, should_block_on_timeout = true)

    assert_equal queue.length, 0
    
    assert_raises ThreadError do
      (@queue_length*2).times { queue.enq(:something) }
    end
  end

  def test_double_less_than_should_timeout_if_set_and_not_raise_exception
    queue = NonBlockingSizedQueue.new(@queue_length)

    assert_equal queue.length, 0
    
    assert_nothing_raised do
      thread = Thread.new {(@queue_length*2).times { queue << :something }}
      thread.join
    end
    
    assert_equal @queue_length, queue.length
  end
  
  def test_double_less_than_block_if_not_set_and_raises_thread_error_sleep_forever
    queue = NonBlockingSizedQueue.new(@queue_length, should_block_on_timeout = true)

    assert_equal queue.length, 0
    
    assert_raises ThreadError do
      (@queue_length*2).times { queue << :something }
    end
  end
end
