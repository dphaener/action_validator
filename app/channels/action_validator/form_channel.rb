# frozen_string_literal: true

module ActionValidator
  class FormChannel < ApplicationCable::Channel
    include ActiveSupport::Configurable
    include ActionController::RequestForgeryProtection

    def subscribed
      stream_from "action_validator_form_channel"
    end

    def unsubscribed
      stop_all_streams
    end

    def validate(data)
      model_class, params = parse_params(data["formData"])
      if model_class.nil?
        Rails.logger.warn("No valid model class found, cannot perform remote validation.")
        ActionCable.server.broadcast("action_validator_form_channel", { errors: {} })
        return
      end

      instance = validated_instance(model_class, params)

      ActionCable.server.broadcast("action_validator_form_channel", { errors: parse_model_errors(instance) })
    end

    private

    def validated_instance(model_class, params)
      instance = model_class.new(params)
      instance.validate
      instance
    end

    def parse_model_errors(instance)
      # TODO: What about errors on :base? Or any other random shit people might add?
      #       I think we can just tell people to add a div with the proper attribute?
      #       Or just don't allow it?
      #
      instance.errors.each_with_object({}) { |error, hash| hash[error.attribute] = error.full_message }
    end

    def parse_params(data)
      parsed_params = Rack::Utils.parse_nested_query(data).without("action", "authenticity_token")
      params = ActionController::Parameters.new(parsed_params).to_unsafe_h
      model_name = params.keys.first
      model_class = model_name.classify.safe_constantize

      [model_class, params[model_name]]
    end
  end
end
