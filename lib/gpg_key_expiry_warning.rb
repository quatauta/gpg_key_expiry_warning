# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

# Print OpenPGP/GnuPG/GPG/PGP keys expiring within a given number of days
module GpgKeyExpiryWarning
end

loader.eager_load
