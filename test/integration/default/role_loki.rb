control "Role Loki" do
  title ""

  describe service("loki") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe firewalld do
    it { should have_port_enabled_in_zone("3100/tcp", "internal") }
    it { should have_port_enabled_in_zone("9096/tcp", "internal") }
  end
end
