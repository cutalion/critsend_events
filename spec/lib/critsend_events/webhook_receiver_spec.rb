require 'spec_helper'

describe CritsendEvents::WebhookReceiver do
  let(:app)         { stub }
  let(:handler)     { stub }
  let(:middleware)  { CritsendEvents::WebhookReceiver.new(app, handler) }
  let(:env)         { Hash.new }
  let(:events_json) { "[]" }
  before { CritsendEvents::Config.stub authentication_key: "key" }

  context "if events posted" do
    let(:env) { {"REQUEST_METHOD" => "POST", "PATH_INFO" => CritsendEvents::Config.mount_point} }
    describe "receive events" do
      before { env["rack.input"] = StringIO.new(events_json) }

      context "if request not signed" do
        it "should response with 403 Forbidden" do
          response.status.should                  == 403
          response.body.should                    == '{"error": "Invalid payload according to our webhooks key"}'
          response.headers["Content-Type"].should == "application/json"
        end
      end

      context "if request signed" do
        before { env["HTTP_X_CRITSEND_WEBHOOKS_SIGNATURE"] = CritsendEvents::SignatureGenerator.generate(CritsendEvents::Config.authentication_key, events_json) }

        it "should response with 200 OK" do
          response.body.should                    == ''
          response.status.should                  == 200
          response.headers["Content-Type"].should == "application/json"
        end

        it "should call registered handler" do
          middleware.processor.should_receive(:process).with(events_json)
          middleware.call(env)
        end
      end

      context "if request has incorrect signature" do
        before { env["HTTP_X_CRITSEND_WEBHOOKS_SIGNATURE"] = "wrong-signature" }

        it "should response with 403 Forbidden" do
          response.status.should                  == 403
          response.body.should                    == '{"error": "Invalid payload according to our webhooks key"}'
          response.headers["Content-Type"].should == "application/json"
        end
      end
    end
  end

  context "if events not posted" do
    context "REQUEST_METHOD not POST" do
      let(:env) { {"REQUEST_METHOD" => "GET", "PATH_INFO" => CritsendEvents::Config.mount_point} }
      it "should pass the request to next middleware" do
        app.should_receive(:call).with(env)
        middleware.call(env)
      end
    end
    context "PATH_INFO does not equal to mount point" do
      let(:env) { {"REQUEST_METHOD" => "POST", "PATH_INFO" => "/"} }
      it "should pass the request to next middleware" do
        app.should_receive(:call).with(env)
        middleware.call(env)
      end
    end
  end

  class Response < Struct.new(:status, :headers, :body)
    def body
      self[:body].read
    end
  end

  def response
    env["rack.input"].rewind
    Response.new(*middleware.call(env))
  end
end
