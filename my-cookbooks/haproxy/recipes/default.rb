package "haproxy"

cookbook_file "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg"
end
