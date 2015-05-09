require "styleguide-api/version"

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

end
