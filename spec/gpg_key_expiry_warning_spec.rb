require "gpg_key_expiry_warning"
require "gpg_key_expiry_warning/version"

RSpec.describe GpgKeyExpiryWarning do
  it "has a version number" do
    expect(GpgKeyExpiryWarning::VERSION).not_to be nil
  end
end
