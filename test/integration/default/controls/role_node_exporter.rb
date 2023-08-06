control "Node Exporter" do
  title ""

  describe docker_container(name: "prvsn-node_exporter") do
    its("image") { should eq "prom/node-exporter:v1.6.1" }
    its("status") { should cmp(/healthy/) }
    its("ports") { should eq "0.0.0.0:9100->9100/tcp, :::9100->9100/tcp" }
  end
end
