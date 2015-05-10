require 'middleman-core'

class StyleGuideAPI::MiddlemanExtension < ::Middleman::Extension
  option :templates, '', 'Glob to load templates'

  def initialize(app, options_hash = {}, &block)
    super

    app.configure :development do
      StyleGuideAPI.live = true
    end

    if options_hash.has_key?(:templates)
      StyleGuideAPI.add_templates options_hash[:templates]
    end
  end

  helpers StyleGuideAPI::Helpers

  helpers do
    def style_template(name, locals = {}, &block)
      locals[:scope] = self
      if block_given?
        template = StyleGuideAPI.data[StyleGuideAPI.theme]["templates"][name]
        type = template["type"].to_sym
        handler_class = ::Padrino::Helpers::OutputHelpers.handlers[type]
        html = handler_class.new(self).capture_from_template(&block)
        block = Proc.new { html }
      end
      StyleGuideAPI::render(name, locals, &block)
    end
  end
end

StyleGuideAPI::MiddlemanExtension.register(:styleguide_api)
