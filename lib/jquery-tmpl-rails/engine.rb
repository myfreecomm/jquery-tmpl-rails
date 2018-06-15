require 'active_support/ordered_options'

module JqueryTmplRails
  class Engine < ::Rails::Engine
    config.jquery_templates = ActiveSupport::OrderedOptions.new
    config.jquery_templates.prefix = ''

    initializer 'sprockets.jquery_templates', after: 'sprockets.environment', group: :all do |app|
      if Gem::Version.new(Sprockets::VERSION) > Gem::Version.new('3')
        app.config.assets.configure do |assets_env|
          assets_env.register_mime_type 'text/template', extensions: ['.tmpl']
          assets_env.register_transformer 'text/template', 'application/javascript', TiltProcessor.new(JqueryTemplate)
        end
      else
        next unless app.assets
        app.assets.register_engine('.tmpl', JqueryTemplate)
      end
    end
  end
end
