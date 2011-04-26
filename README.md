# Passenger+EventMachine

## Installation

```bash
gem install passenger-eventmachine
```

```ruby
gem "passenger-eventmachine"
```

## Usage

```ruby
require 'passenger-eventmachine'

PhusionPassenger::EventMachine.after_boot do
  EM.connect "127.0.0.1", 4000, Connection
end

use PhusionPassenger::EventMachine::Handler
run App.new
```

## Contributors

* Simon Menke

Copyright (c) 2011 Simon Menke, released under the MIT license
