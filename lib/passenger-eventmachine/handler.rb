class PhusionPassenger::EventMachine::Handler

  AsyncResponse = [-1, {}, []].freeze

  def initialize(app)
    @app = app
    unless EM.reactor_running?
      PhusionPassenger::EventMachine::Manager.boot
    end
  end

  def call(env)
    i = dup
    response = PhusionPassenger::EventMachine::Response.new
    env['async.callback'] = response
    EM.schedule do
      i._call(env)
    end
    response.resolve
  end

protected

  def _call(env)
    response = catch(:async) { @app.call(env) }
    if nil === response or AsyncResponse === response
      env['async.callback'].async!
    else
      env['async.callback'].call response
    end
  end

end
