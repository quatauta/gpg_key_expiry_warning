#!/bin/env ruby
# frozen_string_literal: true

require "gpgme"

module GPGKeyExpiryWarning
  module Refinements
    module GPGME
      refine ::GPGME::Key do
        def to_s
          primary_subkey = subkeys[0]
          s = sprintf("%s   %s%d/0x%s %s [%s] [expires: %s]\n",
            primary_subkey.secret? ? "sec" : "pub",
            primary_subkey.pubkey_algo_name,
            primary_subkey.length,
            primary_subkey.fingerprint[-16..-1],
            primary_subkey.timestamp.strftime("%Y-%m-%d"),
            primary_subkey.capability_letters,
            primary_subkey.expires.strftime("%Y-%m-%d"))
          uids.each { |user_id| s << "uid                              #{user_id.name} <#{user_id.email}>\n" }
          subkeys[1..].each { |subkey| s << subkey.to_s }
          s
        end
      end

      refine ::GPGME::SubKey do
        def capability_letters
          capability.map { |c| c.to_s[0] }.join.upcase
        end

        def pubkey_algo_name
          pubkey_algo_names = {
            ::GPGME::PK_DSA => "dsa",
            ::GPGME::PK_ELG => "elg",
            ::GPGME::PK_ELG_E => "elg_e",
            ::GPGME::PK_RSA => "rsa",
          }

          pubkey_algo_names[GPGME::PK_ECC] = "ecc" if defined?(GPGME_PK_ECC)
          pubkey_algo_names[@pubkey_algo] || "?"
        end

        def to_s
          sprintf("%s   %s%d/0x%s %s [%s] [expires: %s]\n",
            secret? ? "ssc" : "sub",
            pubkey_algo_name,
            length,
            (@fpr || @keyid)[-16..-1],
            timestamp.strftime("%Y-%m-%d"),
            capability_letters,
            expires.strftime("%Y-%m-%d"))
        end
      end
    end
  end
end
