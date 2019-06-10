#!/bin/env ruby
# frozen_string_literal: true

module GpgKeyExpiryWarning
  autoload :Command, "gpg_key_expiry_warning/command"
  autoload :Refinements, "gpg_key_expiry_warning/refinements"
  autoload :Version, "gpg_key_expiry_warning/version"
end
