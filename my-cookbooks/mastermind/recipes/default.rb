include_recipe 'git'

directory 'srv/mastermind' do
  user 'www-data'
end

git '/srv/mastermind' do
  repository 'git://github.com/abesto/mastermind.git'
  reference 'master'
  user 'www-data'
end
