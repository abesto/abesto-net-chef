include_recipe 'mysql::server'
include_recipe 'nginx'
include_recipe 'php'
include_recipe 'php::module_mysql'
include_recipe 'php-fpm'

dir = '/srv/formbuilder'
host = 'formbuilder.stage.abesto.net'

directory dir do
  user 'deployer'
end

git dir do
  repository 'git://github.com/abesto/form-builder-web.git'
  reference 'master'
  user 'deployer'
end
  
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
mysql_database 'formbuilder' do
  connection mysql_connection_info
  action :create
end
mysql_database_user 'formbuilder' do
  connection mysql_connection_info
  password node['formbuilder']['mysql_password']
  action :create
end
mysql_database_user 'formbuilder' do
  connection mysql_connection_info
  database_name 'formbuilder'
  action :grant 
end
mysql = "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\""
execute 'db-schema' do
  command "#{mysql} formbuilder < \"#{dir}/db.sql\""
  not_if "#{mysql} -e \"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'formbuilder' AND TABLE_NAME = 'users';\" | grep users"
end

config_editor = Chef::Util::FileEdit.new("#{dir}/system/application/config/config.php")
config_editor.search_file_replace_line /^\$config\['base_url'\].*/, "$config['base_url'] = 'http://#{host}';"
#config_editor.search_file_replace_line /^\$config\['uri_protocol'\].*/, "$config['uri_protocol'] = 'REQUEST_URI';"
config_editor.write_file

db_editor = Chef::Util::FileEdit.new("#{dir}/system/application/config/database.php")
db_editor.search_file_replace_line /^\$db\['default'\]\['username'\].*/, "$db['default']['username'] = 'formbuilder';"
db_editor.search_file_replace_line /^\$db\['default'\]\['password'\].*/, "$db['default']['password'] = '#{node['formbuilder']['mysql_password'].gsub("'", "\'")}';"
db_editor.search_file_replace_line /^\$db\['default'\]\['database'\].*/, "$db['default']['database'] = 'formbuilder';"
db_editor.write_file

template "#{node['nginx']['dir']}/sites-available/formbuilder" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :host => host
  )
end
nginx_site 'formbuilder'
