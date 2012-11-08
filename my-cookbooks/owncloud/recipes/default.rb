include_recipe 'nginx'
include_recipe 'php'
include_recipe 'php-fpm'

version = '4.5.1'
tarbz = '/tmp/owncloud.tar.gz'
dir = '/srv/owncloud'

%w(apache2 php5 php5-json php-xml php-mbstring php5-zip php5-gd
apt-get install php5-sqlite curl libcurl3 libcurl3-dev php5-curl php-pdo).each do |pkg|
  package pkg do action :upgrade end
end

unless ::Dir::exists? dir
  remote_file tarbz do
    source "http://mirrors.owncloud.org/releases/owncloud-#{version}.tar.bz2"
  end
  execute "tzr -xjf #{tarbz} && mv owncloud #{dir} && chown -R www-data:root #{dir}" do
    cwd '/tmp'
  end
end

# Add to nginx
template "#{node['nginx']['dir']}/sites-available/owncloud" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
end
nginx_site 'owncloud'
