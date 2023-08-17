# frozen_string_literal: true

require "time"
require "open3"

require "dependabot/errors"
require "dependabot/shared_helpers"

module Dependabot
  module Python
    module Helpers
      def self.run_poetry_command(command, fingerprint: nil)
        start = Time.now
        command = SharedHelpers.escape_command(command)
        stdout, process = Open3.capture2e(command)
        time_taken = Time.now - start

        # Raise an error with the output from the shell session if Pipenv
        # returns a non-zero status
        return if process.success?

        raise SharedHelpers::HelperSubprocessFailed.new(
          message: stdout,
          error_context: {
            command: command,
            fingerprint: fingerprint,
            time_taken: time_taken,
            process_exit_value: process.to_s
          }
        )
      end
    end
  end
end
