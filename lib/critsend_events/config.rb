module CritsendEvents
  class Config
    class << self
      def mount_point; @@mount_point; end
      def mount_point=(val); @@mount_point = val; end
      @@mount_point = "/critsend/receiver"

      def authentication_key; @@authentication_key; end
      def authentication_key=(val); @@authentication_key = val; end
      @@authentication_key = ""

      def setup
        yield self
      end
    end
  end
end
