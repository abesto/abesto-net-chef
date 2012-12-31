include_recipe 'supervisor'
include_recipe 'nodejs'
include_recipe 'nginx'
include_recipe 'git'

package 'redis-server'

dir = '/srv/are-you-board'
port = 3001

# Create directory
directory dir do
  user 'deployer'
end

# Get the code
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

user 'areyouboard'

# Start the server
supervisor_service 'are-you-board' do
  command "node app.js #{port}"
  user 'areyouboard'
  autorestart true
  directory dir
  redirect_stderr true
  environment(
    'SS_ENV' => 'production'
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
