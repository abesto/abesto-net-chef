include_recipe 'mysql::server'
include_recipe 'database'
include_recipe 'php'
include_recipe 'php::module_mysql'
include_recipe 'php-fpm'

package 'imagemagick'

dir = '/srv/piwigo'

directory dir { user 'www-data' }

# Create DB and DB user
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
mysql_database node['piwigo']['mysql_db'] do
  connection mysql_connection_info
  action :create
end
mysql_database_user node['piwigo']['mysql_user'] do
  connection mysql_connection_info
  password node['piwigo']['mysql_password']
  action :create
end
mysql_database_user node['piwigo']['mysql_user'] do
  connection mysql_connection_info
  database_name node['piwigo']['mysql_db']
  action :grant
end


# Add to nginx
template "#{node['nginx']['dir']}/sites-available/piwigo" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
end
nginx_site 'piwigo'
