require "styleguide-api/version"
require "styleguide-api/helpers"
require "tilt"
require "open-uri"
require "json"

module StyleGuideAPI
  class << self
    attr_accessor :live
    attr_accessor :theme
  end

  class UnknownTemplateError < StandardError
    def initialize(template_name)
      @template_name = template_name
    end

    def message
      "Template '#{@template_name}' is not known."
    end
  end

  def self.initialize
    @live = false
    @templates = {}
    @template_paths = {}
    @data = nil
    @theme = nil
    @stylesheets = {}
  end
  initialize

  def self.data
    return @data if @data and not (live and @template_paths.any?)
    @data = {}
    load_templates
    @data
  end

  def self.load(uri)
    json = open(uri).read
    @data = JSON.parse(json)
  end

  def self.add_templates(glob, options = {})
    current_theme = options[:theme] || theme
    @template_paths[current_theme] ||= []
    @template_paths[current_theme] << glob
  end

  def self.add_stylesheet(file)
    @stylesheets[theme] ||= []
    @stylesheets[theme] << file
  end

  def self.render(template_name, locals = {}, &block)
    scope = locals.delete(:scope) || Object.new
    template = template_for(template_name)
    template.render(scope, locals, &block)
  end

  def self.template_for(name)
    @templates[theme][name] if @templates[theme] && @templates[theme][name]
    template = data[theme]["templates"].fetch(name) do
      fail UnknownTemplateError, name
    end
    @templates[theme] ||= {}
    @templates[theme][name] = Tilt[template["type"]].new { template["source"] }
  end

  def self.theme
    @theme ||= themes.first || "default"
  end

  def self.themes
    (@template_paths.keys + (@data ? @data.keys : [])).uniq
  end

  def self.to_json
    data.to_json
  end

  def self.stylesheets
    data[theme]["stylesheets"] || []
  end

  private
  def self.load_templates
    themes.each do |theme|
      @data[theme] ||= {
        "templates" => {},
        "stylesheets" => @stylesheets[theme]
      }
      @template_paths[theme].each do |glob|
        path = glob.split("*").first
        Dir.glob(glob).each do |file|
          key, type = file.sub("/_", "/").sub(/^#{path}(.+?)\.(\w+)$/, "\\1"), $2
          if Tilt[type]
            @data[theme]["templates"][key] = {
              "source" => File.read(file).strip,
              "type" => type
            }
          end
        end
      end
    end
  end

end

require "styleguide-api/middleman" if defined?(Middleman)
