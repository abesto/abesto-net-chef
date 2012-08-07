include_recipe 'mysql::server'
include_recipe 'database'
include_recipe 'php'
include_recipe 'php::module_mysql'
include_recipe 'php-fpm'


dir = '/srv/blog'

# Extract code/media snapshot
unless File.directory? dir
  directory '/tmp/blog-dist'
  cookbook_file '/tmp/blog-dist/blog.tar.gz' do
    source 'blog.tar.gz'
  end
  execute 'extract-distribution' do
    cwd '/tmp/blog-dist'
    command "tar -xzf blog.tar.gz && mv wordpress #{dir} && chown -R www-data #{dir}"
  end
  directory dir do
    user 'www-data'
  end
  directory '/tmp/blog-dist' do
    action :delete
    recursive true
  end
end

# Create DB and DB user
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
mysql_database node['blog']['mysql_db'] do
  connection mysql_connection_info
  action :create
end
mysql_database_user node['blog']['mysql_user'] do
  connection mysql_connection_info
  password node['blog']['mysql_password']
  action :create
end
mysql_database_user node['blog']['mysql_user'] do
  connection mysql_connection_info
  database_name node['blog']['mysql_db']
  action :grant
end

# Import db snapshot
mysql = "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\""
cookbook_file '/tmp/blog_sql' do
  source 'db.sql'
end
execute 'db-schema' do
  command "#{mysql} #{node['blog']['mysql_db']} < /tmp/blog_sql"
  not_if "#{mysql} -e \"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '#{node['blog']['mysql_db']}' AND TABLE_NAME = 'wp_posts';\" | grep wp_posts"
end
cookbook_file '/tmp/blog_sql' do
  action :delete
end

# Create config file
vars = node['blog'].clone
vars['secret_keys'] = open('https://api.wordpress.org/secret-key/1.1/salt/').read
template "#{dir}/wp-config.php" do
  source 'wp-config.php.erb'
  variables node['blog']
  owner 'www-data'
end

# Add to nginx
template "#{node['nginx']['dir']}/sites-available/blog" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
end
nginx_site 'blog'
