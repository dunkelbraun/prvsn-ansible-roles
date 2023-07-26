control "Internal Network Firewall" do
  title ""

  describe firewalld do
    it { should be_running }
    its("default_zone") { should eq "internal" }
    it { should have_service_enabled_in_zone("ssh", "internal") }
  end

  describe(firewalld.where { zone == "internal" }) do
    its("interfaces") { should eq [["eth1"]] }
  end
end
