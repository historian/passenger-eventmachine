module PhusionPassenger
  module EventMachine
    
    require 'thread'
    require 'eventmachine'
    
    require 'passenger-eventmachine/version'
    require 'passenger-eventmachine/manager'
    require 'passenger-eventmachine/response'
    require 'passenger-eventmachine/handler'
    
    def self.acivate?
      PhusionPassenger.respond_to?(:on_event)
    end

    @after_boot_callbacks = []

    def self.after_boot(&block)
      @after_boot_callbacks.push block
    end

    def self.after_boot_callbacks
      @after_boot_callbacks
    end
    
  end
end
