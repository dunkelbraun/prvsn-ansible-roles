control "Terraform Grafana Load Balancer" do
  title ""

  describe "terraform.tfstate check_results unique statuses" do
    it {
      json = JSON.parse(File.read(input("state_path")))
      check_statuses = json["check_results"].map { |result| result["status"] }.uniq
      expect(check_statuses).to eq ["pass"]
    }
  end

  describe http(input("grafana_url")) do
    its("status") { should eq 302 }
    its("headers.Location") { should eq("/login") }
  end

  describe http(input("grafana_url"), max_redirects: 1) do
    its("status") { should eq 200 }
  end
end
