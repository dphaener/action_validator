# frozen_string_literal: true

require "action_validator/version"
require "action_validator/engine"
require "action_validator/form_builder"

# The main module and configuration for ActionValidator.
#
module ActionValidator
  mattr_accessor :form_error_selector, default: :form_errors
  mattr_accessor :input_error_selector, default: :input_error
  mattr_accessor :default_validate_event, default: :blur

  STIMULUS_SELECTORS = {
    target: "action-validator--form-target",
    controller: "action-validator--form",
    validate_action: "action-validator--form#validate"
  }.freeze

  def self.setup
    yield self
  end
end
