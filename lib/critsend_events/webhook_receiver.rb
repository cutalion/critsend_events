require File.expand_path(__FILE__, 'signature_generator')
require File.expand_path(__FILE__, 'config')

module CritsendEvents
  class WebhookReceiver
    attr_reader :processor

    def initialize(app, handler)
      @app = app
      @processor = WebhookProcessor.new(handler)
    end

    def call(env)
      if events_posted?(env)
        receive_events(env)
      else
        @app.call(env)
      end
    end

    private

    def events_posted?(env)
      return false if env["REQUEST_METHOD"].to_s != "POST"
      return env["PATH_INFO"].to_s == Config.mount_point
    end

    def receive_events(env)
      if request_signed?(env)
        process(env)
        [200, {"Content-Type" => "application/json"}, StringIO.new("")]
      else
        [403, {"Content-Type" => "application/json"}, StringIO.new('{"error": "Invalid payload according to our webhooks key"}')]
      end
    end

    def process(env)
      env['rack.input'].rewind
      data = env['rack.input'].read
      processor.process data
    end

    def request_signed?(env)
      critsend_signature = env["HTTP_X_CRITSEND_WEBHOOKS_SIGNATURE"]
      data               = env['rack.input'].read
      secret_key         = Config.authentication_key
      our_signature      = SignatureGenerator.generate(secret_key, data)

      valid_signature?(critsend_signature, our_signature)
    end

    def valid_signature?(their_signature, our_signature)
      return false if their_signature.to_s.empty?
      our_signature === their_signature
    end
  end
end
