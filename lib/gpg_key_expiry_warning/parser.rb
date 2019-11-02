#!/usr/bin/ruby
# frozen_string_literal: true

require "date"

module GpgKeyExpiryWarning
  class Parser
    # https://gitlab.com/openpgp-wg/rfc4880bis/blob/master/draft-koch-openpgp-rfc4880bis-02.txt,
    # section 9.1 Public Key Algorithms
    ALGORITHMS = {
      1 => :rsa,
      2 => :rsa_encrypt,
      3 => :rsa_sign,
      16 => :elgamal_encrypt,
      17 => :dsa,
      18 => :ecdh,
      19 => :ecdsa,
      20 => :reserved_elgamal_encrypt_or_sign,
      21 => :dh,
      22 => :eddsa,
    }

    CAPABILITIES = {
      a: :auth,
      c: :cert,
      e: :encrypt,
      s: :sign,
    }

    FIELDS = {
      1 => {symbol: :type, conversion: ->(type) { type.to_sym }},
      2 => {symbol: :validity, conversion: ->(validity) { validity.to_sym }},
      3 => {symbol: :length, conversion: ->(length) { length.to_i }},
      4 => {symbol: :algorithm, conversion: ->(algorithm) { Parser.parse_algorithm(algorithm) }},
      5 => {symbol: :id},
      6 => {symbol: :created, conversion: ->(created) { Parser.parse_datetime(created) }},
      7 => {symbol: :expires, conversion: ->(expires) { Parser.parse_datetime(expires) }},
      # 8 => { symbol: :certificate_sn_uid_hash_trust_signature_info, },
      9 => {symbol: :ownertrust, conversion: ->(trust) { trust.to_sym }},
      10 => {symbol: :user_id},
      # 11 => { symbol: :signature_class, },
      12 => {symbol: :capabilities, conversion: ->(capabilities) { Parser.parse_capabilities(capabilities) }},
      # 13 => { symbol: :issuer_fingerprint, },
      # 14 => { symbol: :flag, },
      # 15 => { symbol: :token_sn, },
      # 16 => { symbol: :hash_algorithm, },
      # 17 => { symbol: :curve_name, },
      # 18 => { symbol: :compliance_flags, },
      19 => {symbol: :updated, conversion: ->(updated) { Parser.parse_datetime(updated) }},
      # 20 => { symbol: :origin, },
      # 21 => { symbol: :comment, },
    }

    def self.parse_algorithm(text)
      ALGORITHMS[text.to_i] || :unknown
    end

    def self.parse_capabilities(text)
      text.chars.map { |char| CAPABILITIES[char.to_sym] }.compact
    end

    def self.parse_datetime(text)
      if /\A[0-9]+\Z/.match?(text)
        Time.at(text.to_i)
      else
        DateTime.parse(text).to_time
      end
    end

    # LANG=C gpg --no-options --with-colons --with-fingerprint --with-fingerprint --list-public-keys
    def self.parse_keys(data)
      keys = []

      data.each_line do |line|
        parsed = parse_line(line)

        case parsed[:type]
        when :pub
          keys << parsed
        when :sub
          (keys.last[:subkeys] ||= []) << parsed
        when :uid
          (keys.last[:uids] ||= []) << parsed
        when :fpr
          if keys.last[:subkeys].nil?
            keys.last[:fingerprint] = parsed[:user_id]
          else
            keys.last[:subkeys].last[:fingerprint] = parsed[:user_id]
          end
        end
      end

      keys
    end

    def self.parse_line(line)
      fields = line.strip.split(":")
      parsed = {}

      FIELDS.each do |number, spec|
        value = fields[number - 1]

        if value && !value.empty?
          conversion = spec[:conversion]
          value = conversion.call(value) if conversion
          parsed[spec[:symbol]] = value
        end
      end

      parsed
    end
  end
end
