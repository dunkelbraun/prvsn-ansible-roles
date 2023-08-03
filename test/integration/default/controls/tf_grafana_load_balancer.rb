control "Terraform Grafana Load Balancer" do
  title ""

  describe http(input("grafana_url")) do
    its("status") { should eq 302 }
    its("headers.Location") { should eq("/login") }
  end

  describe http(input("grafana_url"), max_redirects: 1) do
    its("status") { should eq 200 }
  end
end
