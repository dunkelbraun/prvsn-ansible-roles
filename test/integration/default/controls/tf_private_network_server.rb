control "Terraform Private Network Server" do
  title ""

  describe "server name" do
    it { expect(input("private_network_server").fetch(:name)).to eq "test-server" }
  end

  describe "server network_id" do
    it {
      expect(input("private_network_server").fetch(:network)[0][:network_id]).to eq(input("subnet")[:network_id])
    }
  end

  describe "server ipv4" do
    it { expect(input("private_network_server").fetch(:public_net)[0][:ipv4]).to eq(0) }
  end

  describe "server ipv4_enabled" do
    it { expect(input("private_network_server").fetch(:public_net)[0][:ipv4_enabled]).to be false }
  end

  describe "server ipv6" do
    it { expect(input("private_network_server").fetch(:public_net)[0][:ipv6]).to eq(0) }
  end

  describe "server ipv6_enabled" do
    it { expect(input("private_network_server").fetch(:public_net)[0][:ipv6_enabled]).to be false }
  end

  describe "server backups" do
    it { expect(input("private_network_server").fetch(:backups)).to be false }
  end

  describe "server delete_protection" do
    it { expect(input("private_network_server").fetch(:delete_protection)).to be false }
  end

  describe "server keep disk" do
    it { expect(input("private_network_server").fetch(:keep_disk)).to be true }
  end

  describe "server server type" do
    it { expect(input("private_network_server").fetch(:server_type)).to eq("cpx21") }
  end
end
