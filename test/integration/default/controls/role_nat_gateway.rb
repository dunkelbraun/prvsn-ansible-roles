input("internal_interface", value: "eth1")

control "Role NAT Gateway" do
  title ""

  describe firewalld do
    it { should be_running }
    it { should have_service_enabled_in_zone("ssh", "internal") }
  end

  describe command("sysctl net.ipv4.ip_forward") do
    its("stdout") { should match "net.ipv4.ip_forward = 1" }
  end

  describe(firewalld.where { zone == "internal" }) do
    its("interfaces") { should eq [[input("internal_interface")]] }
  end

  describe(firewalld.where { zone == "public" }) do
    its("interfaces") { should eq [["eth0"]] }
    it { should have_masquerade_enabled }
  end

  describe file("/etc/firewalld/policies/nat-gateway.xml") do
    its("content") do
      should match <<~FILE
        <?xml version="1.0" encoding="utf-8"?>
        <policy target="ACCEPT">
          <ingress-zone name="internal"/>
          <egress-zone name="public"/>
        </policy>
      FILE
    end
  end
end
