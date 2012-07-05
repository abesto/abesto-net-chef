include_recipe "dotdeb::php53"

%w{php5-fpm php5-cgi}.each do |package|
  package "#{package}" do
    action :upgrade
  end
end

cookbook_file "/etc/php5/fpm/php5-fpm.conf" do
  source "php5-fpm.conf"
  mode 0644
  owner "root"
  group "root"
end

service "php5-fpm" do
  action [ :enable, :start ]
end
