include_recipe 'supervisor'
include_recipe 'nodejs'
include_recipe 'nginx'
include_recipe 'git'

dir = '/srv/algo'
port = 3000

# Create directory
directory dir do
  user 'deployer'
end

# Get the code
git dir do
  repository 'git://github.com/abesto/algo.git'
  reference 'nodejs'
  user 'deployer'
end

# Install dependencies
execute 'npm install' do
  cwd dir
  user 'deployer'
  environment(
    'HOME' => '/home/deployer'
  )
end

# chown directories where files will be generated
user 'algo'
execute "chown -R algo #{dir}/public"

# Start the server
supervisor_service 'algo' do
  command "node node_modules/coffee-script/bin/coffee app.coffee #{port}"
  user 'algo'
  autorestart true
  directory dir  
  redirect_stderr true
  #environment(
    #'NODE_ENV' => 'production'
  #)
end

# Configure nginx reverse proxy
template "#{node['nginx']['dir']}/sites-available/algo" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :port => port
  )
end

nginx_site 'algo'
