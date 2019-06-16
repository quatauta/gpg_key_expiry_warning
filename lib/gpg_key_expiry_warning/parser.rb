#!/usr/bin/ruby

# LANG=C gpg --no-options --with-colons --with-fingerprint --with-fingerprint --list-public-keys

module GPGKeyExpiryWarning
  class Parser
    FIELDS = {
       1 => :type,
       2 => :validity,
       3 => :length,
       4 => :algorithm,
       5 => :key_id,
       6 => :creation,
       7 => :expiration,
      # 8 => :certificate_sn_uid_hash_trust_signature_info,
       9 => :ownertrust,
      10 => :user_id,
      # 11 => :signature_class,
      12 => :capabilities,
      # 13 => :issuer_fingerprint,
      # 14 => :flag,
      # 15 => :token_sn,
      # 16 => :hash_algorithm,
      # 17 => :curve_name,
      # 18 => :compliance_flags,
      19 => :update,
      # 20 => :origin,
      # 21 => :comment,
    }

    def self.parse_keys(data)
      keys = []

      data.each_line do |line|
        fields = line.strip.split(':')
        parsed = {}
        FIELDS.each do |number, symbol|
          parsed[symbol] = fields[number - 1] unless fields[number - 1].nil? || fields[number - 1].empty?
        end

        keys << parsed
      end

      keys
    end
  end
end
