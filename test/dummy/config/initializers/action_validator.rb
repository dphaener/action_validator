# frozen_string_literal: true

ActionValidator.setup do |config|
  config.form_error_selector = :form_errors
  config.input_error_selector = :input_error
  config.default_validate_event = :input
end
