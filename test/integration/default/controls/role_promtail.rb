input("loki_server", value: "localhost")

control "Role Promtail" do
  title ""

  describe service("promtail") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe file("/etc/promtail/config.yml") do
    its(:content) do
      should match(%r{http://#{input("loki_server")}:3100/loki/api/v1/push})
    end
  end

  describe user("promtail") do
    it { should exist }
    its("groups") { should eq %w[nogroup root adm systemd-journal docker] }
  end
end
