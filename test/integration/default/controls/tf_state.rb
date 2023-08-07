control "Terraform State" do
  title ""
  json = JSON.parse(File.read(input("state_path")))

  json["check_results"].each do |result|
    describe result["config_addr"].split(".").last.to_s do
      it { expect(result["status"]).to eq "pass" }
    end
  end
end
