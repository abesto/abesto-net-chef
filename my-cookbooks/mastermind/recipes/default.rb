include_recipe 'git'
include_recipe 'nginx'

directory 'srv/mastermind' do
  user 'www-data'
end

git '/srv/mastermind' do
  repository 'git://github.com/abesto/mastermind.git'
  reference 'master'
  user 'www-data'
end

template "#{node['nginx']['dir']}/sites-available/mastermind" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
end
nginx_site 'mastermind'
