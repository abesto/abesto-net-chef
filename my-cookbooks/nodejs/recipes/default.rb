apt_repository "nodejs-ppa" do
  uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu"
  distribution node.lsb.codename
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

package 'nodejs' do action :upgrade end
