include_recipe 'python::virtualenv'
include_recipe 'supervisor'

dir = '/opt/my-apps/python-ircd'
virtualenv_dir = "#{dir}/env"

['python-dev', 'libevent-dev'].each do |pkg|
  package pkg do
    action :install
  end
end


git dir do
  repository 'git://github.com/abesto/python-ircd.git'
  reference 'master'
  user 'deployer'
  group 'root'
end

python_virtualenv virtualenv_dir do
  owner 'deployer'
  group 'root'
  interpreter 'python2.7'
  action :create
end

script 'Install Requirements' do
  interpreter 'bash'
  user 'deployer'
  group 'root'
  code "#{virtualenv_dir}/bin/pip install -r #{dir}/requirements.txt"
end

user 'python-ircd'
supervisor_service 'python-ircd' do
  command "#{virtualenv_dir}/bin/python #{dir}/application.py"
  user 'python-ircd'
  autorestart true
  directory dir  
  redirect_stderr true
end

firewall_rule 'python-ircd' do
  protocol :tcp
  port 6667
  action :allow
end
