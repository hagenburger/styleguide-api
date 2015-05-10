module StyleGuideAPI::Helpers

  def style_template(name, locals = {}, &block)
    StyleGuideAPI::render(name, locals, &block)
  end

end
