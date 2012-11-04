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

cookbook_file '/etc/ssh/sshd_config' do
  source 'sshd_config'
  mode '644'
  notifies :reload, resources(:service => 'ssh')
end

['zsh'].each do |pkg|
  package pkg do
    action :upgrade
  end
end
