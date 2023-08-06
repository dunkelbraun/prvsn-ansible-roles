control "Loki" do
  title ""

  describe docker_container(name: "prvsn-loki") do
    its("image") { should eq "grafana/loki:2.8.0" }
    its("status") { should cmp(/healthy/) }
    its("ports") { should eq "0.0.0.0:3100->3100/tcp, :::3100->3100/tcp" }
  end
end
