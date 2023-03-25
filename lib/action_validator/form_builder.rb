module ActionValidator
  class FormBuilder < ActionView::Helpers::FormBuilder
    def render_field(attribute, options = {})
      options[:data] ||= {}
      options[:data].merge!(input_data_options(attribute, options))

      yield
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      options[:data] ||= {}
      options[:data].merge!(input_data_options(attribute, options))

      super
    end

    def input_data_options(attribute, options)
      validate_event = options.delete(:validate_event) || ActionValidator.default_validate_event

      {
        'action-validator--form-target' => :input,
        'is-dirty' => false,
        'remote-validate' => options.delete(:remote_validate) || false,
        'action' => "#{validate_event}->action-validator--form#validate",
        'attribute' => attribute,
        'valid' => !options[:required]
      }
    end

    def submit(value = nil, options = {}, &block)
      if value.is_a?(Hash)
        options = value
        value = nil
      end
      options[:data] ||= {}
      options[:data].merge!('action-validator--form_target' => :submit)

      super
    end

    def text_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def number_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def date_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def text_area(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def email_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def phone_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def check_box(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def datetime_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def datetime_local_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def file_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def hidden_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def month_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def password_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def radio_button(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def range_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def rich_text_area(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def search_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def telephone_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def time_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def url_field(attribute, options = {})
      render_field(attribute, options) { super }
    end

    def week_field(attribute, options = {})
      render_field(attribute, options) { super }
    end
  end
end
