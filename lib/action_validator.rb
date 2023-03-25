require 'action_validator/version'
require 'action_validator/engine'
require 'action_validator/form_builder'

module ActionValidator
  extend ActiveSupport::Autoload

  mattr_accessor :form_error_selector
  @form_error_selector = :form_errors

  mattr_accessor :input_error_selector
  @input_error_selector = :input_error

  mattr_accessor :default_validate_event
  @default_validate_event = :blur

  def self.setup
    yield self
  end
end
