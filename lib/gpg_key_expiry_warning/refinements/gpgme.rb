#!/bin/env ruby

require "gpgme"

module GpgKeyExpiryWarning
  module Refinements
    module GPGME
      refine ::GPGME::Key do
        def to_s
          primary_subkey = subkeys[0]
          primary = {
            type: primary_subkey.secret? ? "sec" : "pub",
            algo: primary_subkey.pubkey_algo_name,
            length: primary_subkey.length,
            id: primary_subkey.fingerprint[-16..-1],
            date: primary_subkey.timestamp.strftime("%Y-%m-%d"),
            capabilities: primary_subkey.capability_letters,
            expires: primary_subkey.expires.strftime("%Y-%m-%d"),
          }
          string = "%<type>s   %<algo>s%<length>d/0x%<id>s %<date>s [%<capabilities>s] [expires: %<expires>s]\n" % primary

          uids.each do |user_id|
            string << "uid                              #{user_id.name} <#{user_id.email}>\n"
          end

          subkeys[1..].each { |subkey| string << subkey.to_s }
          string
        end
      end

      refine ::GPGME::SubKey do
        def capability_letters
          capability.map { |capability| capability.to_s[0] }.join.upcase
        end

        def pubkey_algo_name
          pubkey_algo_names = {
            ::GPGME::PK_DSA => "dsa",
            ::GPGME::PK_ELG => "elg",
            ::GPGME::PK_ELG_E => "elg_e",
            ::GPGME::PK_RSA => "rsa",
          }

          pubkey_algo_names[GPGME::PK_ECC] = "ecc" if defined?(::GPGME_PK_ECC)
          pubkey_algo_names[@pubkey_algo] || "?"
        end

        def to_s
          key = {
            type: secret? ? "ssc" : "sub",
            algo: pubkey_algo_name,
            length: length,
            id: (@fpr || @keyid)[-16..-1],
            date: timestamp.strftime("%Y-%m-%d"),
            capabilities: capability_letters,
            expires: expires.strftime("%Y-%m-%d"),
          }

          "%<type>s   %<algo>s%<length>d/0x%<id>s %<date>s [%<capabilities>s] [expires: %<expires>s]\n" % key
        end
      end
    end
  end
end
