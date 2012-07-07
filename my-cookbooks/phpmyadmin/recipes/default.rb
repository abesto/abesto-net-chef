include_recipe 'nginx'
include_recipe 'php'
include_recipe 'php::module_mysql'
include_recipe 'php-fpm'
include_recipe 'mysql::server'

package 'phpmyadmin'
package 'php5-mcrypt'

template "#{node['nginx']['dir']}/sites-available/phpmyadmin" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
end

nginx_site 'phpmyadmin'
