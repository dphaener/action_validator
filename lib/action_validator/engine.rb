# frozen_string_literal: true

module ActionValidator
  # The Rails engine for ActionValidator
  #
  class Engine < ::Rails::Engine
    isolate_namespace ActionValidator

    initializer "action_validator.helpers", before: :load_config_initializers do
      ActiveSupport.on_load(:action_controller_base) do
        helper ActionValidator::Engine.helpers
      end
    end

    initializer "action_validator.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end

    initializer "action_validator.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app/javascript")
      end
    end
  end
end
