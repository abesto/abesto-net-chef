include_recipe 'nginx'
include_recipe 'php'
include_recipe 'php-fpm'
include_recipe 'php::module_mysql'
include_recipe 'mysql::server'
include_recipe 'database'

version = '1.6.2'  # TODO: Upgrade needs manual help
tarbz = '/tmp/ttrss.tar.gz'
dir = '/srv/ttrss'

package 'php5-mysql'

user 'ttrss'

# Make sure we have the code
unless File.directory? dir
  remote_file tarbz do
    source "http://tt-rss.org/download/tt-rss-#{version}.tar.gz"
    checksum "d4935787a59cebc81d1958e573485875d3a81178d3eef5edb9609d2276e78d07"
  end

  directory dir do
    owner 'ttrss'
  end

  bash "untar" do
    user "root"
    cwd dir
    code "tar -xzf #{tarbz} && mv tt-rss-#{version}/* ./ && rm -r tt-rss-#{version} && chown -R ttrss . "
  end
end

# MySQL
## Privileges
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
mysql_database node['ttrss']['mysql_db'] do
  connection mysql_connection_info
  action :create
end
mysql_database_user node['ttrss']['mysql_user'] do
  connection mysql_connection_info
  password node['ttrss']['mysql_password']
  action :create
end
mysql_database_user node['ttrss']['mysql_user'] do
  connection mysql_connection_info
  database_name node['ttrss']['mysql_db']
  action :grant
end
## Schema
mysql = "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\""
execute 'db-schema' do
  command "#{mysql} #{node['ttrss']['mysql_db']} < #{dir}/schema/ttrss_schema_mysql.sql"
  not_if "#{mysql} -e \"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '#{node['ttrss']['mysql_db']}' AND TABLE_NAME = 'ttrss_users';\" | grep ttrss_users"
end

# Add to nginx
template "#{node['nginx']['dir']}/sites-available/ttrss" do
  source "nginx.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:dir => dir)
end
nginx_site 'ttrss'
