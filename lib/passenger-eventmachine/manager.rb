module PhusionPassenger::EventMachine::Manager
  EM = ::EventMachine

  def boot
    start_eventmachine
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      if forked
        reset_eventmachine
        start_eventmachine
      end
    end
    PhusionPassenger.on_event(:stopping_worker_process) do
      EM.schedule { EM.stop_event_loop }
    end

    self
  end

private

  def reset_eventmachine
    if EM.reactor_running?

      EM.instance_variable_get('@conns').each do |_, c|
        c.detach rescue nil
      end

      reactor_thread = EM.instance_variable_get('@reactor_thread')
      if reactor_thread
        reactor_thread.exit
        if reactor_thread.respond_to?(:kill!) and reactor_thread.alive?
          reactor_thread.kill!
        end
      end

      pool = EM.instance_variable_get('@threadpool')
      if pool
        pool.each { |t| t.exit }
        pool.each do |t|
          next unless t.alive?
          # ruby 1.9 has no kill!
          t.respond_to?(:kill!) ? t.kill! : t.kill
        end
        pool.clear
      end

      EM.release_machine

      EM.instance_variable_set('@threadpool', nil)
      EM.instance_variable_set('@tails', nil)
      EM.instance_variable_set('@conns', nil)
      EM.instance_variable_set('@acceptors', nil)
      EM.instance_variable_set('@timers', nil)
      EM.instance_variable_set('@wrapped_exception', nil)
      EM.instance_variable_set('@next_tick_queue', nil)
      EM.instance_variable_set('@reactor_running', false)
      EM.instance_variable_set('@reactor_thread', nil)
    end
  end

  def start_eventmachine
    main_thread = Thread.current
    @thread = Thread.new do
      begin
        sleep 1
        EM.run do
          main_thread.wakeup
          # just boot em
        end
      rescue Object => e
        main_thread.wakeup
        main_thread.raise e
      else
        main_thread.wakeup
      end
    end
    Thread.stop

    is_spawner = $0.include?('Passenger ApplicationSpawner')

    PhusionPassenger::EventMachine.after_boot_callbacks.each do |block|
      EM.schedule { block.call(is_spawner) }
    end
  end

  extend self

end
