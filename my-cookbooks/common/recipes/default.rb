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
