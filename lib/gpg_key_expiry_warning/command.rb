#!/bin/env ruby

require "cri"
require "gpgme"

module GpgKeyExpiryWarning
  class Command
    def initialize
      @command = define_command
    end

    class Runner < Cri::CommandRunner
      def run
        days = options.fetch(:days)

        Runner.find_keys(days).each do |key|
          puts key
        end
      end

      def self.find_keys(days)
        GPGME::Key.find(:secret).select { |key| subkeys_expire?(key, days) }
      end

      def self.subkeys_expire?(key, days)
        key.subkeys.any? { |subkey| key_expires?(subkey, days) }
      end

      def self.key_expires?(key, days)
        key.expires? && key.expires < (Time.now + 60 * 60 * 24 * days)
      end
    end

    def define_command
      Cri::Command.define do
        name        $PROGRAM_NAME.to_s
        usage       "#{$PROGRAM_NAME} [--days=DAYS]"
        summary     "Print your GnuPG keys which expire soon"
        description "Print your own GnuPG (secret) keys which expire within 31 days, or the amount of days you specify."

        flag :h, :help, "show help for this command" do |_value, cmd|
          puts cmd.help
          exit 0
        end

        option :d, :days, "Days within keys expire", default: 31, argument: :required, transform: method(:Integer)
        runner Runner
      end
    end

    def run(opts_and_args)
      @command.run(opts_and_args)
    end
  end
end
