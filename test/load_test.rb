require "test_helper"

describe StyleGuideAPI do

  after do
    StyleGuideAPI.initialize
  end

  describe "loading templates" do

    it "should load templates" do
      StyleGuideAPI.load_templates "test/fixtures/load_test/**/*.*"
      assert_equal({
        "user" => {
          source: ".user= name",
          type: "haml"
        },
        "products/ball" => {
          source: "<div class=\"product\"><%= name %></div>",
          type: "erb"
        }
      }, StyleGuideAPI.data[:templates])
    end

  end

end
