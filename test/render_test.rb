require "test_helper"
require "tilt/haml"

describe StyleGuideAPI do

  before do
    StyleGuideAPI.load_templates "test/fixtures/render_test/*.haml"
  end

  after do
    StyleGuideAPI.initialize
  end

  describe "rendering templates" do

    it "should render templates" do
      result = StyleGuideAPI.render("user", name: "Homer")
      assert_equal <<-HTML.strip, result.strip
        <div class='user'>Homer</div>
      HTML
    end

    it "should accept blocks" do
      result = StyleGuideAPI.render("block", name: "Homer") { "Simpson" }
      assert_equal <<-HTML.unindent.strip, result.strip
        <div class='first-name'>Homer</div>
        <div class='last-name'>Simpson</div>
      HTML
    end

  end

end
