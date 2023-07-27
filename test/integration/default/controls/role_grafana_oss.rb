control "Role Grafana OSS" do
  title ""

  describe package("grafana") do
    it { is_expected.to be_installed }
  end

  describe service("grafana-server") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe firewalld do
    it { should have_port_enabled_in_zone("3000/tcp", "internal") }
  end
end
