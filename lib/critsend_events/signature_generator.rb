module CritsendEvents
  class SignatureGenerator
    def self.generate(secret_key, message)
      digest = OpenSSL::Digest::Digest.new('sha256')
      OpenSSL::HMAC.hexdigest(digest, secret_key, message)
    end
  end
end
