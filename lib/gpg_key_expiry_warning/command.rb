#!/bin/env ruby
# frozen_string_literal: true

require "cri"
require "gpgme"
require "gpg_key_expiry_warning/refinements/gpgme"

module GpgKeyExpiryWarning
  class Command
    def initialize
      @command = define_command
    end

    class Runner < Cri::CommandRunner
      using GpgKeyExpiryWarning::Refinements::GPGME

      def run
        days = options.fetch(:days)

        GPGME::Key.find(:secret).select do |key|
          key.subkeys.any? do |sub|
            sub.expires? && sub.expires < (Time.now + 60 * 60 * 24 * days)
          end
        end.each do |key|
          puts key.to_s
        end
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
