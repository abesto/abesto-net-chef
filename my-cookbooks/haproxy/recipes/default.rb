package "haproxy"

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg"
  variables(
            :ipaddress => node['ipaddress']
            )
end
