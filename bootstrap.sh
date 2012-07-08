#!/bin/bash
echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
sudo mkdir -p /etc/apt/trusted.gpg.d
gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
apt-get update
echo yes | apt-get install opscode-keyring
echo yes | apt-get upgrade
echo yes | apt-get install git chef
echo 'cookbook_path ["/var/chef/cookbooks", "/var/chef/my-cookbooks"]' > /etc/chef/solo.rb
echo 'json_attribs "/var/chef/node.json"' >> /etc/chef/solo.rb
git clone git://github.com/abesto/abesto-net-chef.git /var/chef

echo --------------------------------------------------------------------------------
echo Bootstrapping is complete. Now you should:
echo 1. Edit /var/chef/node.json to set passwords / apps to run
echo 2. Run chef-solo
echo 3. Reboot
