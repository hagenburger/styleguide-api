require "styleguide-api/version"
require "tilt"

module StyleGuideAPI

  def self.initialize
    @templates = {}
    @data = {
      templates: {}
    }
  end
  initialize

  def self.data
    @data
  end

  def self.load_templates(glob)
    path = glob.split("*").first
    Dir.glob(glob).each do |file|
      key, type = file.sub("/_", "/").sub(/^#{path}(.+?)\.(\w+)$/, "\\1"), $2
      @data[:templates][key] = {
        source: File.read(file).strip,
        type: type
      }
    end
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

end
