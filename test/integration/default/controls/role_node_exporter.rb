control "Role Node Exporter" do
  title ""

  describe service("node_exporter") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe command("ufw status verbose") do
    its(:stdout) { is_expected.to match(/Status: active/) }
    its(:stdout) { should match(%r{9100/tcp\s+ALLOW IN\s+#{input('hetzner_network_ip_range')}}) }
  end
end
