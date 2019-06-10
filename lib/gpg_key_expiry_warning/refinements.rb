#!/bin/env ruby
# frozen_string_literal: true

module GpgKeyExpiryWarning
  module Refinements
    autoload :GPGME, "gpg_key_expiry_warning/refinements/gpgme"
  end
end
