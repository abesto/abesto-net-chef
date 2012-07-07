user 'deployer' do
  home '/home/deployer'
end

directory '/home/deployer'do
  user 'deployer'
  group 'deployer'
  mode '700'
end

directory '/opt/my-apps' do
  owner 'deployer'
  group 'root'
  action :create
end

firewall "ufw" do
  action :enable
end

firewall_rule "ssh" do
  port 22
  protocol :tcp
  action :allow
end

firewall_rule "http" do
  port 80
  protocol :tcp
  action :allow
end
