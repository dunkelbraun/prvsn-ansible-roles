control "Node Exporter" do
  title ""

  describe service("node_exporter") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe firewalld do
    it { should have_port_enabled_in_zone("9100/tcp", "internal") }
  end
end
