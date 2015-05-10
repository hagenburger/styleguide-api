module StyleGuideAPI::Helpers

  def style_template(name, locals = {}, &block)
    StyleGuideAPI::render(name, locals, &block)
  end

  def style_css
    StyleGuideAPI.stylesheets.map do |url|
      %Q(<link href="#{url}" rel="stylesheet">)
    end.join("\n")
  end

end
