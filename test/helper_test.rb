require "test_helper"

describe StyleGuideAPI::Helpers do

  before do
    StyleGuideAPI.add_templates "test/fixtures/render_test/*.haml"
    StyleGuideAPI.add_stylesheet "base.css"
    StyleGuideAPI.add_stylesheet "more.css"
    @helpers = Class.new do
      extend StyleGuideAPI::Helpers
    end
  end

  after do
    StyleGuideAPI.initialize
  end

  describe "rendering templates" do

    it "should render templates" do
      result = @helpers.style_template("user", name: "Homer")
      assert_equal <<-HTML.strip, result.strip
        <div class='user'>Homer</div>
      HTML
    end

    it "should accept blocks" do
      result = @helpers.style_template("block", name: "Homer") { "Simpson" }
      assert_equal <<-HTML.unindent.strip, result.strip
        <div class='first-name'>Homer</div>
        <div class='last-name'>Simpson</div>
      HTML
    end

  end

  describe "stylesheets" do

    it "should create stylesheet link tags" do
      result = @helpers.style_css
      assert_equal <<-HTML.unindent.strip, result
        <link href="base.css" rel="stylesheet">
        <link href="more.css" rel="stylesheet">
      HTML
    end

  end

end

