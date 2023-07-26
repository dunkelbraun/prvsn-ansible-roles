control "Docker" do
  title ""

  describe service("containerd") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service("docker") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
