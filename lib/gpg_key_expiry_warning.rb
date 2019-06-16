#!/bin/env ruby

module GPGKeyExpiryWarning
  autoload :Command, "gpg_key_expiry_warning/command"
  autoload :Version, "gpg_key_expiry_warning/version"
  autoload :Parser,  "gpg_key_expiry_warning/parser"
end
