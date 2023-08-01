control "Terraform Grafana Load Balancer" do
  title ""

  describe "load balancer name" do
    it {
      expect(input("grafana_load_balancer").fetch(:name)).to eq("grafana-#{input("hetzner_network_name")}-prvsn.dev-lb")
    }
  end

  describe "load balancer network" do
    describe "load_balancer_id" do
      it {
        expect(input("grafana_load_balancer_network").fetch(:load_balancer_id)).to eq(input("grafana_load_balancer").fetch(:id).to_i)
      }
    end

    describe "subnet_id" do
      it {
        expected_subnet_id = "#{input("network").fetch(:id)}-#{input("subnet").fetch(:ip_range)}"
        expect(input("grafana_load_balancer_network").fetch(:subnet_id)).to eq(expected_subnet_id)
      }
    end

    describe "enable_public_interface" do
      it { expect(input("grafana_load_balancer_network").fetch(:enable_public_interface)).to be true }
    end
  end

  describe "load balancer target" do
    describe "target count" do
      it { expect(input("grafana_load_balancer_targets").length).to be 1 }
    end

    describe "type" do
      it { expect(input("grafana_load_balancer_targets")[0].fetch(:type)).to eq("server") }
    end

    describe "use_private_ip" do
      it { expect(input("grafana_load_balancer_targets")[0].fetch(:use_private_ip)).to be true }
    end

    describe "server_id" do
      it {
        expect(input("grafana_load_balancer_targets")[0].fetch(:server_id)).to eq(input("grafana_server").fetch(:id).to_i)
      }
    end

    describe "load_balancer_id" do
      it {
        expected_load_balancer_id = input("grafana_load_balancer").fetch(:id).to_i
        expect(input("grafana_load_balancer_targets")[0].fetch(:load_balancer_id)).to eq(expected_load_balancer_id)
      }
    end
  end

  describe "managed_cerfificate" do
    it { expect(input("grafana_managed_cerfificate").fetch(:domain_names).length).to eq 1 }
  end

  describe "managed_cerfificate_domain_name" do
    it {
      expected_domain_name = /^grafana-#{input("hetzner_network_name")}.prvsn\.dev$/
      expect(input("grafana_managed_cerfificate").fetch(:domain_names)[0]).to match(expected_domain_name)
    }
  end

  describe "grafana load balancer service" do
    describe "destination_port" do
      it { expect(input("grafana_load_balancer_service").fetch(:destination_port)).to eq 3000 }
    end

    describe "listen_port" do
      it { expect(input("grafana_load_balancer_service").fetch(:listen_port)).to eq 443 }
    end

    describe "protocol" do
      it { expect(input("grafana_load_balancer_service").fetch(:protocol)).to eq "https" }
    end

    describe "load_balancer_id" do
      it {
        expeced_load_balancer_id = input("grafana_load_balancer").fetch(:id)
        expect(input("grafana_load_balancer_service").fetch(:load_balancer_id)).to eq expeced_load_balancer_id
      }
    end

    describe "certificates" do
      it {
        expected_certificates = [input("grafana_managed_cerfificate").fetch(:id).to_i]
        expect(input("grafana_load_balancer_service").fetch(:http)[0].fetch(:certificates)).to eq expected_certificates
      }
    end

    describe "redirect_http" do
      it { expect(input("grafana_load_balancer_service").fetch(:http)[0].fetch(:redirect_http)).to be true }
    end
  end

  describe "grafana load balancer record" do
    describe "name" do
      it {
        expect(input("grafana_load_balancer_record").fetch(:name)).to eq "grafana-#{input("hetzner_network_name")}"
      }
    end

    describe "ttl" do
      it { expect(input("grafana_load_balancer_record").fetch(:ttl)).to eq 60 }
    end

    describe "value" do
      it {
        expect(input("grafana_load_balancer_record").fetch(:value)).to eq input("grafana_load_balancer").fetch(:ipv4)
      }
    end
  end

  describe http("https://#{input("grafana_managed_cerfificate").fetch(:domain_names)[0]}") do
    its("status") { should eq 302 }
    its("headers.Location") { should eq("/login") }
  end

  describe http("https://#{input("grafana_managed_cerfificate").fetch(:domain_names)[0]}", max_redirects: 1) do
    its("status") { should eq 200 }
  end
end
