control "Terraform Grafana" do
  title ""

  describe "server name" do
    it { expect(input("grafana_server").fetch(:name)).to eq "grafana-#{input("hetzner_network_name")}" }
  end

  describe "server network_id" do
    it {
      expect(input("grafana_server").fetch(:network)[0][:network_id]).to eq(input("subnet")[:network_id])
    }
  end

  describe "server ipv4" do
    it { expect(input("grafana_server").fetch(:public_net)[0][:ipv4]).to eq(0) }
  end

  describe "server ipv4_enabled" do
    it { expect(input("grafana_server").fetch(:public_net)[0][:ipv4_enabled]).to be false }
  end

  describe "server ipv6" do
    it { expect(input("grafana_server").fetch(:public_net)[0][:ipv6]).to eq(0) }
  end

  describe "server ipv6_enabled" do
    it { expect(input("grafana_server").fetch(:public_net)[0][:ipv6_enabled]).to be false }
  end

  describe "server backups" do
    it { expect(input("grafana_server").fetch(:backups)).to be false }
  end

  describe "server delete_protection" do
    it { expect(input("grafana_server").fetch(:delete_protection)).to be false }
  end

  describe "server keep disk" do
    it { expect(input("grafana_server").fetch(:keep_disk)).to be true }
  end

  describe "server server type" do
    it { expect(input("grafana_server").fetch(:server_type)).to eq("cpx21") }
  end

  describe "server location" do
    it {
      locations = {
        "eu-central" => %w[nbg1 hel1 fsn1],
        "us-east" => %w[ash],
        "us-west" => %w[hil]
      }.freeze
      available_locations_in_zone = locations[input("hetzner_network_zone")]
      regex = Regexp.new(available_locations_in_zone.join("|"))
      expect(input("grafana_server").fetch(:location)).to match(regex)
    }
  end

  describe "server ssh keys" do
    it { expect(input("grafana_server").fetch(:ssh_keys)).to eq(["12940863"]) }
  end

  describe "server labels keys" do
    it {
      expected_labels = {
        "created-by": "prvsn-hcloud-starter",
        gateway: input("nat_gateway").fetch(:network)[0].fetch(:ip),
        network: input("hetzner_network_name"),
        role: "grafana"
      }
      expect(input("grafana_server").fetch(:labels)).to eq(expected_labels)
    }
  end
end
