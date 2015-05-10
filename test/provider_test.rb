require "test_helper"
require "json"

describe StyleGuideAPI do

  after do
    StyleGuideAPI.initialize
  end

  describe "providing templates" do

    it "should provide templates as JSON" do
      StyleGuideAPI.add_templates "test/fixtures/load_test/*.haml"
      StyleGuideAPI.add_stylesheet "http://abc.xy/styles.css"
      json = <<-JSON
        {
          "default": {
            "stylesheets": ["http://abc.xy/styles.css"],
            "templates": {
              "user": {
                "source": ".user= name",
                "type": "haml"
              }
            }
          }
        }
      JSON
      assert_equal(JSON.parse(json), JSON.parse(StyleGuideAPI.to_json))
    end

  end

end

