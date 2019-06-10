#!/bin/env ruby
# frozen_string_literal: true

module GPGKeyExpiryWarning
  module Refinements
    autoload :GPGME, "gpg_key_expiry_warning/refinements/gpgme"
  end
end
