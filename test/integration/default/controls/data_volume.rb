control "Data Volume" do
  title ""

  describe(etc_fstab.where { mount_point == "/data" }) do
    its("file_system_type") { should cmp "ext4" }
    its("mount_options") { should eq [%w[discard nofail defaults]] }
    its("dump_options") { should cmp 0 }
    its("file_system_options") { should cmp 0 }
  end

  describe mount("/data") do
    it { should be_mounted }
    its("device") { should match(%r{/dev/\w+$}) }
    its("type") { should eq "ext4" }
  end

  describe filesystem("/data") do
    its("size_kb") { should be >= 30_000_000 }
    its("size_kb") { should be <= 31_000_000 }
    its("type") { should cmp "ext4" }
  end
end
