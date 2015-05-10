require "styleguide-api/version"
require "styleguide-api/helpers"
require "tilt"

module StyleGuideAPI
  class << self
    attr_accessor :live
  end

  def self.initialize
    @live = false
    @templates = {}
    @template_paths = []
    @data = nil
  end
  initialize

  def self.data
    return @data if @data and not live
    @data = { templates: {} }
    load_templates
    @data
  end

  def self.add_templates(glob)
    @template_paths << glob
  end

  def self.render(template_name, locals = {}, &block)
    template = template_for(template_name)
    template.render(Object.new, locals, &block)
  end

  def self.template_for(name)
    @templates[name] if @templates[name]
    template = data[:templates][name]
    @templates[name] = Tilt[template[:type]].new { template[:source] }
  end

  private
  def self.load_templates
    @template_paths.each do |glob|
      path = glob.split("*").first
      Dir.glob(glob).each do |file|
        key, type = file.sub("/_", "/").sub(/^#{path}(.+?)\.(\w+)$/, "\\1"), $2
        @data[:templates][key] = {
          source: File.read(file).strip,
          type: type
        }
      end
    end
  end

end
