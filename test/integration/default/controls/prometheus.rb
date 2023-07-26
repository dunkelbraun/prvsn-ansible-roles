input("hetzner_network_name_internal", value: "a_network_name")
input("hetzner_read_token", value: "abcd")

control "Prometheus" do
  title ""

  describe service("prometheus") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe firewalld do
    it { should have_port_enabled_in_zone("9090/tcp", "internal") }
  end

  describe file("/etc/prometheus/prometheus.yml") do
    its("content_as_yaml") do
      should include(
        {
          "global" => {
            "scrape_interval" => "15s", "evaluation_interval" => "15s"
          },
          "scrape_configs" => [
            { "job_name" => "hetzner_service_discovery",
              "hetzner_sd_configs" => [
                {
                  "role" => "hcloud",
                  "bearer_token" => input("hetzner_read_token").to_s,
                  "port" => 9100
                }
              ],
              "relabel_configs" => [
                {
                  "source_labels" => ["__meta_hetzner_hcloud_private_ipv4_#{input("hetzner_network_name_internal")}"],
                  "replacement" => "${1}:9100", "target_label" => "__address__"
                },
                {
                  "source_labels" => ["__meta_hetzner_server_name"],
                  "target_label" => "instance"
                }
              ] },
            { "job_name" => "file_service_discovery",
              "file_sd_configs" => [
                "files" => ["targets/file_service_discoverer.yml"]
              ] }
          ]
        }
      )
    end
  end

  describe user("pfsd") do
    it { should exist }
    its("groups") { should eq %w[pfsd syslog prometheus] }
  end

  describe package("ruby") do
    it { should be_installed }
  end

  describe file("/usr/local/bin/prometheus_discoverer") do
    its("mode") { should cmp "0755" }
    its("owner") { should eq "root" }
    its("group") { should eq "root" }
  end

  describe crontab("pfsd") do
    its("commands") do
      should include "HCLOUD_READ_TOKEN=#{input("hetzner_read_token")} /usr/local/bin/prometheus_discoverer"
    end
  end

  prometheus_discoverer_cmd = "HCLOUD_READ_TOKEN=#{input("hetzner_read_token")} /usr/local/bin/prometheus_discoverer"
  describe crontab("pfsd").commands(prometheus_discoverer_cmd) do
    its("minutes") { should cmp "*/2" }
    its("hours") { should cmp "*" }
    its("days") { should cmp "*" }
    its("months") { should cmp "*" }
    its("weekdays") { should cmp "*" }
  end

  describe directory("/etc/prometheus/targets") do
    its("owner") { should eq "root" }
    its("group") { should eq "prometheus" }
    its("mode") { should cmp "0770" }
  end
end
