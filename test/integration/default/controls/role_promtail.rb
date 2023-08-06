input("loki_server", value: "localhost")

control "Promtail" do
  title ""

  describe docker_container(name: "prvsn-promtail") do
    its("image") { should eq "grafana/promtail:2.8.3" }
    its("status") { should cmp(/healthy/) }
    its("ports") { should be_empty }
  end
end
