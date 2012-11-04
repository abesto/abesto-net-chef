file '/usr/local/bin/update-ufw-cloudflare' do
  owner 'root'
  group 'root'
  mode 0700
  source 'update-ufw-cloudflare'
end

cron 'update-ufw-cloudflare' do
  hour '*'
  minute '0'
  command '/usr/local/bin/update-ufw-cloudflare'
  user 'root'
  mailto 'abesto0@gmail.com'
end
