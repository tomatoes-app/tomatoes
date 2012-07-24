maintainer       "Promet Solutions"
maintainer_email "marius@promethost.com"
license          "Apache 2.0"
description      "Installs MongoDB"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2.0"

%w{ ubuntu debian }.each do |os|
  supports os
end
