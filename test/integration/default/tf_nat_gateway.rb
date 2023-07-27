control "Terraform NAT Gateway" do
  title ""

  describe "name" do
    it { expect(input("nat_gateway").fetch(:name)).to eq "nat-#{input("hetzner_network_name")}" }
  end

  describe "keep disk" do
    it { expect(input("nat_gateway").fetch(:keep_disk)).to be false }
  end

  describe "backups" do
    it { expect(input("nat_gateway").fetch(:backups)).to be false }
  end

  describe "delete protection" do
    it { expect(input("nat_gateway").fetch(:delete_protection)).to be false }
  end

  describe "image" do
    it { expect(input("nat_gateway").fetch(:image)).to eq("ubuntu-22.04") }
  end

  describe "datacenter" do
    it {
      datacenters = {
        "eu-central" => %w[nbg1-dc3 hel1-dc2 fsn1-dc14],
        "us-east" => %w[ash-dc1],
        "us-west" => %w[hil-dc1]
      }
      available_datacenters_in_zone = datacenters[input("subnet").fetch(:network_zone)]
      regex = Regexp.new(available_datacenters_in_zone.join("|"))
      expect(input("nat_gateway").fetch(:datacenter)).to match(regex)
    }
  end

  describe "network ID" do
    it {
      network_id = input("nat_gateway").fetch(:network).first.fetch(:network_id)
      expect(network_id).to eq(input("network").fetch(:id).to_i)
    }
  end

  describe "IP" do
    it {
      ip = input("nat_gateway").fetch(:network).first.fetch(:ip)
      expected_ip = input("network").fetch(:ip_range).gsub("0.0/16", "1.1")
      expect(ip).to eq(expected_ip)
    }
  end

  describe "server type" do
    it { expect(input("nat_gateway")[:server_type]).to eq("cpx11") }
  end
end
