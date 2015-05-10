require "test_helper"

describe StyleGuideAPI do

  after do
    StyleGuideAPI.initialize
  end

  describe "loading templates" do

    it "should load templates" do
      StyleGuideAPI.add_templates "test/fixtures/load_test/**/*.*"
      data = {
        "user" => {
          source: ".user= name",
          type: "haml"
        },
        "products/ball" => {
          source: "<div class=\"product\"><%= name %></div>",
          type: "erb"
        }
      }
      assert_equal(data, StyleGuideAPI.data["default"][:templates])

      FileUtils.cp "test/fixtures/load_test/user.haml",
                   "test/fixtures/load_test/new-user.haml"
      assert_equal(data, StyleGuideAPI.data["default"][:templates])

      FileUtils.rm "test/fixtures/load_test/new-user.haml"
    end

    it "should dynamically load templates" do
      StyleGuideAPI.live = true
      StyleGuideAPI.add_templates "test/fixtures/load_test/**/*.*"
      assert_equal %w(products/ball user),
                   StyleGuideAPI.data["default"][:templates].keys.sort

      FileUtils.cp "test/fixtures/load_test/user.haml",
                   "test/fixtures/load_test/new-user.haml"
      assert_equal %w(new-user products/ball user),
                   StyleGuideAPI.data["default"][:templates].keys.sort

      FileUtils.rm "test/fixtures/load_test/new-user.haml"
    end

  end

end
