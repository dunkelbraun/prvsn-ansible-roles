input("internal_interface", value: "eth1")

control "Role NAT Gateway" do
  title ""

  describe service("ufw") do
    it { should be_running }
  end

  describe command("ufw status verbose") do
    its(:stdout) { is_expected.to match(/Status: active/) }
    its(:stdout) { should match(%r{22/tcp\s+\(OpenSSH\)\s+ALLOW IN\s+ Anywhere}) }
    its(:stdout) { should match(%r{22/tcp\s+\(OpenSSH \(v6\)\)\s+ALLOW IN\s+ Anywhere \(v6\)}) }
  end
end
