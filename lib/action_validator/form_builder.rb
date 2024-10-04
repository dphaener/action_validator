# frozen_string_literal: true

module ActionValidator
  # A custom FormBuilder class that renders inputs with all the necessary attributes for the ActionValidator Stimulus
  # controller to work.
  #
  class FormBuilder < ActionView::Helpers::FormBuilder
    def select(method, choices = nil, options = {}, html_options = {}, &block) # :nodoc:
      options[:data] ||= {}
      options[:data].merge!(input_data_options(attribute, options))

      super
    end

    def error(attribute, options = {}) # :nodoc:
      options[:data] ||= {}
      options[:data][ActionValidator::STIMULUS_SELECTORS[:target]] = :error
      options[:data][:attribute] = attribute

      @template.tag(:div, { **options, id: attribute })
    end

    def submit(value = nil, options = {}, &block) # :nodoc:
      if value.is_a?(Hash)
        options = value
        value = nil
      end
      options[:data] ||= {}
      options[:data].merge!("action-validator--form-target" => :submit)

      super
    end

    def text_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def number_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def date_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def text_area(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def email_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def phone_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def check_box(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def datetime_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def datetime_local_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def file_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def hidden_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def month_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def password_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def radio_button(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def range_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def rich_text_area(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def search_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def telephone_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def time_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def url_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    def week_field(attribute, options = {}) # :nodoc:
      render_field(attribute, options) { super }
    end

    private

    def render_field(attribute, options = {})
      options[:data] ||= {}
      options[:data].merge!(input_data_options(attribute, options))

      yield
    end

    def input_data_options(attribute, options)
      validate_event = options.delete(:validate_event) || ActionValidator.default_validate_event
      {
        ActionValidator::STIMULUS_SELECTORS[:target] => :input,
        "is-dirty" => false,
        "remote-validate" => options.delete(:remote_validate) || false,
        "action" => "#{validate_event}->#{ActionValidator::STIMULUS_SELECTORS[:validate_action]}",
        "attribute" => attribute,
        "valid" => !options[:required]
      }
    end
  end
end
