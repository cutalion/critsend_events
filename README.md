# CritsendEvents

Accepts Critsend events with Ruby on Rails
[Critsend Event API](http://www.critsend.com/event-api/)

## Installation

Add this line to your application's Gemfile:

    gem 'critsend_events'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install critsend_events

## Usage

- install it
- add middleware
- write an event receiver
- add config to initializers with Critsend authentication key

```ruby
# application.rb

config.middleware.use "CritsendEvents::WebhookReceiver", "CritsendEventsReceiver"



# app/models/critsend_events_receiver.rb

class CritsendEventsReceiver
  def handle(events)
    Rails.logger.info "Events from Critsend: #{events.inspect}"
  end
end



# config/initializers/critsend_config.rb

CritsendEvents::Config.setup do |config|
  config.authentication_key = ENV["CRITSEND_WEBHOOKS_AUTH_KEY"]
  # config.mount_point = "/critsend/receiver" // optional, default
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
