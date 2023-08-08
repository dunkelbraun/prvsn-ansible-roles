control "Without Data Volume" do
  title ""

  describe(etc_fstab.where { mount_point == "/data" }) do
    it { should_not be_configured }
  end

  describe mount("/data") do
    it { should_not be_mounted }
  end
end
