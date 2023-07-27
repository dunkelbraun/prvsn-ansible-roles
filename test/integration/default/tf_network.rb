control "Terraform Network" do
  title ""

  describe "name" do
    it { expect(input("network").fetch(:name)).to eq input("hetzner_network_name") }
  end

  describe "CIDR" do
    it { expect(input("network").fetch(:ip_range)).to eq input("hetzner_network_ip_range") }
  end

  describe "delete protection" do
    it { expect(input("network").fetch(:delete_protection)).to be false }
  end

  describe "expose routes to vswitch" do
    it { expect(input("network").fetch(:expose_routes_to_vswitch)).to be false }
  end

  describe "labels" do
    it { expect(input("network").fetch(:labels)).to eq({ "created-by": "prvsn-hcloud-starter" }) }
  end

  describe "network zone" do
    it { expect(input("subnet").fetch(:network_zone)).to eq input("hetzner_network_zone") }
  end

  describe "CIDR" do
    it {
      expect(input("subnet").fetch(:ip_range)).to eq input("hetzner_network_ip_range").gsub(".0.0/16",
                                                                                            ".1.0/24")
    }
  end

  describe "gateway IP" do
    it {
      expect(input("subnet").fetch(:gateway)).to eq input("hetzner_network_ip_range").gsub(".0.0/16", ".0.1")
    }
  end
end
