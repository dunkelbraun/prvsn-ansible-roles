control "Role Grafana OSS" do
  title ""

  describe package("grafana") do
    it { is_expected.to be_installed }
  end

  describe service("grafana-server") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe command("ufw status verbose") do
    its(:stdout) { is_expected.to match(/Status: active/) }
    its(:stdout) { should match(%r{3000/tcp\s+ALLOW IN\s+#{input('hetzner_network_ip_range')}}) }
  end
end
