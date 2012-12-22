include_recipe 'nginx'
include_recipe 'php'
include_recipe 'php-fpm'

version = '4.5.1'
tarbz = '/tmp/owncloud.tar.gz'
dir = '/srv/owncloud'

package 'php5-sqlite'
package 'owncloud' do action :upgrade end

# Add to nginx
template "#{node['nginx']['dir']}/sites-available/owncloud" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:dir => '/usr/share/owncloud')
end
nginx_site 'owncloud'
