class PhusionPassenger::EventMachine::Response

  def initialize
    @mutex    = Mutex.new
    @response = ConditionVariable.new
  end

  def call(response)
    @mutex.synchronize do
      if @queue
        @status_code, @headers, body = *response
        push body if body
      else
        @status_code, @headers, @body = *response
      end
      @response.signal
    end
    self
  end

  def async!
    @queue = Queue.new
    @body  = self
  end

  def push(chunks)
    if Array === chunks
      chunks = chunks.flatten
    else
      chunks = [chunks]
    end

    chunks.each do |chunk|
      @queue.push([:chunk, chunk])
    end

    self
  end

  def finish
    @queue.push([:finish])
  end

  def resolve
    return [@status_code, @headers, @body] if @status_code

    @mutex.synchronize do
      @response.wait(@mutex)
      [@status_code, @headers, @body]
    end
  end

  def each
    while item = @queue.pop
      case item[0]
      when :chunk
        yield(item[1])
      when :finish
        return
      end
    end
  end

end
