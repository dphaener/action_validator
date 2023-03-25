module ActionValidator
  class FormChannel < ApplicationCable::Channel
    def subscribed
      stream_from 'form_channel'
    end

    def unsubscribed
      stop_all_streams
    end

    def validate(data)
      model, params = parse_params(data)
      instance = model.new(params)
      instance.validate
      errors = instance.errors
      model_errors =
        errors
        .to_hash
        .map { |attr, _| [attr, errors.full_messages_for(attr)] }
        .to_h
      base_errors = model_errors.delete(:base) || []

      ActionCable.server.broadcast(
        'form_channel',
        { baseErrors: base_errors, modelErrors: model_errors }
      )
    end

    private

    def parse_params(data)
      params = data.without('action', 'authenticity_token')
      parsed_params = Rack::Utils.parse_nested_query(params.to_query)
      parameters = ActionController::Parameters.new(parsed_params)
      model_name = parameters.keys.first
      model = model_name.classify.constantize
      allowed_attributes = model.validators.flat_map(&:attributes).uniq

      [model, parameters.require(model_name).permit(allowed_attributes)]
    end
  end
end
