module ActionValidator
  module FormHelper
    def validator_form_for(record, options = {}, &block)
      options[:builder] = ActionValidator::FormBuilder
      options[:data] ||= {}
      options[:data][:controller] = :form

      form_for(record, options, &block)
    end

    def validator_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
      options[:builder] = ActionValidator::FormBuilder
      options[:data] ||= {}
      options[:data].merge!(
        controller: 'action-validator--form',
        form_error_selector_value: ActionValidator.form_error_selector,
        input_error_selector_value: ActionValidator.input_error_selector,
        'action-validator--form-model-name-value' => model&.class&.name&.underscore
      )

      form_with(model: model, scope: scope, url: url, format: format, **options, &block)
    end

    def validator_error(attribute, options = {})
      style = options.delete(:style) || 'color: red; font-size: 12px'
      options[:data] ||= {}
      options[:data]['action-validator--form-target'] = :error
      options[:data][:attribute] = attribute

      tag.div({ **options, id: attribute, style: style })
    end
  end
end
