input("hetzner_network_name_internal", value: "a_network_name")
input("hetzner_read_token", value: "abcd")

control "Prometheus" do
  title ""

  describe docker_container(name: "prvsn-prometheus") do
    its("image") { should eq "prom/prometheus:v2.46.0" }
    its("status") { should cmp(/healthy/) }
    its("ports") { should eq "9090/tcp" }
  end

  describe(docker.containers.where { names == "prvsn-prometheus" }) do
    its("status") { should cmp(/healthy/) }
  end

  describe docker_container(name: "prvsn-service_discovery") do
    its("image") { should eq "ruby:3.2.2-slim" }
    its("status") { should cmp(/healthy/) }

    its("labels") { should include "ofelia.enabled=true" }
    its("labels") { should include "ofelia.job-exec.file_sd_exporter.schedule=@every 2m" }
    its("labels") { should include "ofelia.job-exec.file_sd_exporter.command=service_discovery" }

    its("ports") { should be_empty }
  end

  describe(docker_container(name: "prvsn-ofelia")) do
    its("image") { should eq "mcuadros/ofelia:v0.3.7" }
    its("status") { should cmp(/Up/) }
    its("ports") { should be_empty }
  end

  describe(docker_container(name: "prvsn-hcloud_load_balancer_exporter")) do
    its("image") { should eq "services-hcloud_load_balancer_exporter" }
    its("status") { should cmp(/healthy/) }
    its("ports") { should eq "8000/tcp" }
  end
end
