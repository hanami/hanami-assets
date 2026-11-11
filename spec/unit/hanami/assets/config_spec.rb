# frozen_string_literal: true

RSpec.describe Hanami::Assets::Config do
  subject(:config) { described_class.new }

  describe "setting readers" do
    it "defines a reader for every setting" do
      expect(described_class.public_instance_methods(false))
        .to include(:node_command, :path_prefix, :subresource_integrity, :base_url)
    end

    it "returns the default values" do
      expect(config.node_command).to eq "node"
      expect(config.path_prefix).to eq "/assets"
      expect(config.subresource_integrity).to eq []
      expect(config.base_url).to be_a Hanami::Assets::BaseUrl
    end

    it "returns values given at initialization" do
      config = described_class.new(path_prefix: "/public", base_url: "https://cdn.example.com")

      expect(config.path_prefix).to eq "/public"
      expect(config.base_url.to_s).to eq "https://cdn.example.com"
    end

    it "returns values assigned through the writers" do
      config.subresource_integrity = [:sha256]
      config.base_url = "https://cdn.example.com"

      expect(config.subresource_integrity).to eq [:sha256]
      expect(config.crossorigin?("https://other.example.com/app.js")).to be true
      expect(config.crossorigin?("https://cdn.example.com/app.js")).to be false
    end
  end
end
