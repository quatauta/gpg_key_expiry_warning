require "gpg_key_expiry_warning"
require "gpg_key_expiry_warning/version"

RSpec.describe GPGKeyExpiryWarning do
  it "has a version number" do
    expect(GPGKeyExpiryWarning::VERSION).not_to be nil
  end
end
