control "Grafana OSS" do
  title ""

  describe(docker.containers.where { names == "prvsn-grafana" }) do
    its("status") { should cmp(/healthy/) }
  end
end
