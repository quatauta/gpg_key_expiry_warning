#!/bin/env ruby
# frozen_string_literal: true

require "cri"
require "gpgme"

module GPGME
  module KeyCommon
    def expires_soon?(days = 31)
      expires? && @expires < (Time.now + 60 * 60 * 24 * days).to_i
    end
  end

  class Key
    def self.find_expires_soon(secret, keys_or_names = nil, purposes = [], days = 31)
      find(secret, keys_or_names, purposes).select { |k| k.subkeys.any? { |sub| sub.expires_soon?(days) } }
    end

    def to_s
      primary_subkey = subkeys[0]
      s = sprintf("%s   %s%d/0x%s %s [%s] [expires: %s]%s\n",
        primary_subkey.secret? ? "sec" : "pub",
        primary_subkey.pubkey_algo_name,
        primary_subkey.length,
        primary_subkey.fingerprint[-16..-1],
        primary_subkey.timestamp.strftime("%Y-%m-%d"),
        primary_subkey.capability_letters,
        primary_subkey.expires.strftime("%Y-%m-%d"),
        primary_subkey.expires_soon? ? " *** expires soon ***" : "")
      uids.each do |user_id|
        s << "uid                              #{user_id.name} <#{user_id.email}>\n"
      end
      subkeys[1..].each do |subkey|
        s << subkey.to_s
      end
      s
    end
  end

  class SubKey
    def capability_letters
      capability.map { |c| c.to_s[0] }.join.upcase
    end

    def pubkey_algo_name
      pubkey_algo_names = {
        GPGME::PK_DSA => "dsa",
        GPGME::PK_ELG => "elg",
        GPGME::PK_ELG_E => "elg_e",
        GPGME::PK_RSA => "rsa",
      }

      pubkey_algo_names[GPGME::PK_ECC] = "ecc" if defined?(GPGME_PK_ECC)
      pubkey_algo_names[@pubkey_algo] || "?"
    end

    def to_s
      sprintf("%s   %s%d/0x%s %s [%s] [expires: %s]%s\n",
        secret? ? "ssc" : "sub",
        pubkey_algo_name,
        length,
        (@fpr || @keyid)[-16..-1],
        timestamp.strftime("%Y-%m-%d"),
        capability_letters,
        expires.strftime("%Y-%m-%d"),
        expires_soon? ? " *** expires soon ***" : "")
    end
  end
end

module KeyExpiryWarning
  class Command
    def initialize
      @command = define_command
    end

    def define_command
      Cri::Command.define do
        name        "#{$0}"
        usage       "#{$0} [--days=DAYS] [--benchmark]"
       #aliases     :ds, :stuff
        summary     "Print your GnuPG keys which expire soon"
        description "Print your own GnuPG (secret) keys which expire within 31 days, or the amount of days you specify."

        flag :h, :help, "show help for this command" do |value, cmd|
          puts cmd.help
          exit 0
        end

        option :b, :benchmark, "Do a benchmark", argument: :forbidden
        option :d, :days, "The number of days within keys expire", default: 31, argument: :required, transform: method(:Integer)

        run do |opts, args, cmd|
          days = opts.fetch(:days)
          GPGME::Key.find_expires_soon(:secret, nil, [], days).each { |key| puts key }

          if opts.fetch(:benchmark)
            require "benchmark/ips"
            Benchmark.ips do |bm|
              [1, 31, 365, 365*2, 365*5].each do |days|
                bm.report("#{days} days:") { GPGME::Key.find_expires_soon(:secret, nil, [], days) }
              end
            end
          end
        end
      end
    end

    def run(opts_and_args)
      @command.run(opts_and_args)
    end
  end
end

if $0 == __FILE__
  KeyExpiryWarning::Command.new.run(ARGV)
end
