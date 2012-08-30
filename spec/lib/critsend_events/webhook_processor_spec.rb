require 'spec_helper'

describe CritsendEvents::WebhookProcessor do
  class TestHandler
    def handle(*args); end
  end

  it "should initialize handler if handler is a string" do
    processor = CritsendEvents::WebhookProcessor.new("TestHandler")
    processor.handler.should be_a TestHandler
  end

  describe ".process" do
    let(:raw_data)    { '[{"category": "soft_bounce"}]' }
    let(:parsed_data) { JSON.parse(raw_data) }
    let(:handler)     { TestHandler.new }

    it "should convert raw data to json and pass it to registered handler" do
      processor = CritsendEvents::WebhookProcessor.new(handler)
      handler.should_receive(:handle).with(parsed_data)
      processor.process(raw_data)
    end
  end
end
