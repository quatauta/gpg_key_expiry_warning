require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module GpgKeyExpiryWarning
end

loader.eager_load
