require "gpg_key_expiry_warning"
require "gpg_key_expiry_warning/command"
require "gpg_key_expiry_warning/version"

RSpec.describe GpgKeyExpiryWarning do
  it "has a version number" do
    expect(GpgKeyExpiryWarning::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end
