require "test_helper"
require "tilt/haml"

describe StyleGuideAPI do

  after do
    StyleGuideAPI.initialize
  end

  describe "rendering templates" do

    it "should render templates" do
      StyleGuideAPI.add_templates "test/fixtures/themes_test/red/*.haml", theme: "red"
      StyleGuideAPI.add_templates "test/fixtures/themes_test/blue/*.haml", theme: "blue"

      result = StyleGuideAPI.render("user", name: "Homer")
      assert_match "user-red", result.strip

      StyleGuideAPI.theme = "blue"
      result = StyleGuideAPI.render("user", name: "Homer")
      assert_match "user-blue", result.strip
    end

  end

end
