module ActionValidator
  class Engine < ::Rails::Engine
    isolate_namespace ActionValidator
    config.eager_load_namespaces << ActionValidator
    config.autoload_once_paths = %W[
      #{root}/app/channels
      #{root}/app/helpers
    ]

    initializer 'action_validator.helpers', before: :load_config_initializers do
      ActiveSupport.on_load(:action_controller_base) do
        helper ActionValidator::Engine.helpers
      end
    end
  end
end
