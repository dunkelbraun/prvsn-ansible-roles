control "Terraform State" do
  title ""

  describe "terraform.tfstate check_results unique statuses" do
    it {
      json = JSON.parse(File.read(input("state_path")))
      check_statuses = json["check_results"].map { |result| result["status"] }.uniq
      expect(check_statuses).to eq ["pass"]
    }
  end
end
