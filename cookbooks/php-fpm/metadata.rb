maintainer       "Yevgeniy Viktorov"
maintainer_email "wik@rentasite.com.ua"
license          "Apache 2.0"
description      "Installs and maintain php-fpm sapi"
version          "0.1.0"
recipe           "php-fpm", "Installs php-fpm"

%w{ debian }.each do |os|
  supports os
end

%w{ dotdeb }.each do |cb|
  depends cb
end
