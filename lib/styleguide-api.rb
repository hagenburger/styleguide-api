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

  def self.initialize
    @live = false
    @templates = {}
    @template_paths = {}
    @data = nil
    @theme = nil
  end
  initialize

  def self.data
    return @data if @data and not live
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
    data[theme]["stylesheets"] ||= []
    data[theme]["stylesheets"] << file
  end

  def self.render(template_name, locals = {}, &block)
    scope = locals.delete(:scope) || Object.new
    template = template_for(template_name)
    template.render(scope, locals, &block)
  end

  def self.template_for(name)
    @templates[theme][name] if @templates[theme] && @templates[theme][name]
    template = data[theme]["templates"][name]
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

  private
  def self.load_templates
    themes.each do |theme|
      @data[theme] ||= { "templates" => {} }
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
