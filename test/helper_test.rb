require "test_helper"

describe StyleGuideAPI::Helpers do

  before do
    StyleGuideAPI.load_templates "test/fixtures/render_test/*.haml"
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

end

