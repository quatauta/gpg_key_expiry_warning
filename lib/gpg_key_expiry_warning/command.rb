# frozen_string_literal: true

require "cri"

module GpgKeyExpiryWarning
  # Run the commandline
  #
  # +GpgKeyExpiryWarning::Runner+ will get the list of key from +gpg+ and print the keys
  # expiring withing the given number of days.
  #
  # Examples
  #
  #    $ gpg_key_expiry_warning --help
  #    NAME
  #        gpg_key_expiry_warning - Print your GnuPG keys which expire soon
  #
  #    USAGE
  #        gpg_key_expiry_warning [--days=DAYS]
  #
  #    DESCRIPTION
  #        Print your own GnuPG (secret) keys which expire within 31 days, or the
  #        amount of days you specify.
  #
  #    OPTIONS
  #        -d --days=<value>      Days within keys expire (default: 31)
  #        -h --help              show help for this command
  #
  #    $ gpg_key_expiry_warning --days 400
  #    Keys or subkeys expiring until 2022-01-27 14:44:08 +0100 (400 days):
  #
  #    pub   rsa2048/0xA8D0FF51860E2615 2017-12-27 22:04:49 +0100 [SC] [expires: 2023-01-04]
  #          Key fingerprint = 78AB56E016E71D04579B7A72A8D0FF51860E2615
  #    uid                   [ultimate] Daniel Schoemer <daniel.schoemer@gmx.net>
  #    sub   rsa2048/0x133007E82005F2A2 2017-12-27 [A] [expires: 2022-01-04]
  #    sub   rsa2048/0x4846DE89DFF5A2F1 2017-12-27 [E] [expires: 2022-01-04]
  #    sub   rsa2048/0xA243284A6DC82699 2017-12-27 [S] [expires: 2022-01-04]
  class Command
    def initialize
      @command = define_command
    end

    # Run the command with options and arguments
    class Runner < Cri::CommandRunner
      KEY_FORMAT = "%<type>s   %<algorithm>s%<length>d/0x%<id>s %<created>s [%<capabilities>s] [expires: %<expires>s]"
      FINGERPRINT_FORMAT = "      Key fingerprint = %<fingerprint>s"
      UID_FORMAT = "%<type>s                   [%<validity>s] %<user_id>s"

      public_constant :KEY_FORMAT
      public_constant :FINGERPRINT_FORMAT
      public_constant :UID_FORMAT

      def run
        expire_days = options[:days]
        expire_time = Time.new + expire_days * 24 * 60 * 60
        expiring_keys = expiring_keys(parse_key_list, expire_time)

        puts "Keys or subkeys expiring until #{expire_time} (#{expire_days} days):"
        puts_keys(expiring_keys)
      end

      def key_list
        `LANG=C gpg --no-options --with-colons --with-fingerprint --with-fingerprint --list-public-keys`
      end

      def parse_key_list
        GpgKeyExpiryWarning::Parser.parse_keys(key_list)
      end

      def expiring_keys(keys, expire_time)
        keys.select { |key| key_expires?(key, expire_time) }
      end

      def key_expires?(key, expire_time)
        key[:expires] < expire_time || key[:subkeys]&.any? { |sub| sub[:expires] < expire_time }
      end

      def puts_keys(keys)
        keys.each do |key|
          puts
          puts_key(key)
        end
      end

      def puts_key(key)
        puts format(KEY_FORMAT, key)
        puts format(FINGERPRINT_FORMAT, key)
        puts_uids(key)
        puts_subkeys(key)
      end

      def puts_uids(key)
        key[:uids].each do |uid|
          puts_uid(uid)
        end
      end

      def puts_uid(uid)
        puts format(UID_FORMAT, uid)
      end

      def puts_subkeys(key)
        key[:subkeys].each do |subkey|
          puts_subkey(subkey)
        end
      end

      def puts_subkey(subkey)
        puts format(KEY_FORMAT, subkey)
      end
    end

    def define_command
      Cri::Command.define do
        name $PROGRAM_NAME.to_s
        usage "#{$PROGRAM_NAME} [--days=DAYS]"
        summary "Print your GnuPG keys which expire soon"
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
