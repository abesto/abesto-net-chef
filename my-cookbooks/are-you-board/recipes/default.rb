include_recipe 'supervisor'
include_recipe 'nodejs'
include_recipe 'nginx'
include_recipe 'git'

dir = '/srv/are-you-board'
port = 3001

# Create directory
directory dir do
  user 'deployer'
end

# Get the code
execute "chown -R deployer #{dir}/public"
git dir do
  repository 'git://github.com/abesto/are-you-board.git'
  reference 'master'
  user 'deployer'
end

# Install dependencies
execute 'npm install' do
  cwd dir
  user 'deployer'
  environment('HOME' => '/home/deployer')
end

# chown directories where files will be generated
user 'areyouboard'
directory "#{dir}/builtAssets" do
  owner 'areyouboard'
end
execute "chown -R areyouboard #{dir}/public"

# Start the server
supervisor_service 'are-you-board' do
  command "node app.js #{port}"
  user 'areyouboard'
  autorestart true
  directory dir
  redirect_stderr true
  environment(
    'NODE_ENV' => 'production'
  )
end

# Configure nginx reverse proxy
template "#{node['nginx']['dir']}/sites-available/are-you-board" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :port => port
  )
end

nginx_site 'are-you-board'
