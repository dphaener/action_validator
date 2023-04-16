# frozen_string_literal: true

module ActionValidator
  # Form helpers that will render a standard Rails `form_for` or `form_with` that has all of the necessary attributes
  # added for the ActionValidator Stimulus controller to work.
  #
  module FormHelper
    # A wrapper around the Rails form_for helper. This method can be used exactly the same as the standard Rails helper.
    #
    def validator_form_for(record, options = {}, &block)
      merge_form_options(options)

      form_for(record, options, &block)
    end

    # A wrapper around the Rails form_with helper. This method can be used exactly the same as the standard Rails
    # helper.
    #
    def validator_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
      merge_form_options(options)

      form_with(model: model, scope: scope, url: url, format: format, **options, &block)
    end

    # Renders an unstyled div with the correct Stimulus data attributes on it.
    #
    def validator_error(attribute, options = {})
      options[:data] ||= {}
      options[:data][ActionValidator::STIMULUS_VALUES[:target]] = :error
      options[:data][:attribute] = attribute

      tag(:div, { **options, id: attribute })
    end

    private

    def merge_form_options(options)
      options[:builder] = ActionValidator::FormBuilder
      options[:data] ||= {}
      options[:data].merge!(
        controller: ActionValidator::STIMULUS_VALUES[:controller],
        form_error_selector_value: ActionValidator.form_error_selector,
        input_error_selector_value: ActionValidator.input_error_selector
      )
    end
  end
end
