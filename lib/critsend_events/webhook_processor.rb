module CritsendEvents
  class WebhookProcessor
    attr_reader :handler
    def initialize(handler)
      handler = constantize(handler).new if handler.is_a?(String)
      @handler = handler
    end

    def process(data)
      events = JSON.parse(data)
      @handler.handle(events) if @handler.respond_to?(:handle)
    end

    private

    def constantize(handler)
      if handler.respond_to?(:constantize)
        handler.constantize
      else
        Module.const_get(handler)
      end
    end
  end
end
