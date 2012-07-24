#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: mongodb
# Recipe:: repo
#
# Copyright 2010, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

return unless ["ubuntu", "debian"].include?(node[:platform])

execute "request mongodb key" do
  command "gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7F0CEB10"
  not_if "gpg --list-keys 7F0CEB10"
end

execute "install mongodb key" do
  command "gpg -a --export 7F0CEB10 | apt-key add -"
  not_if "apt-key list | grep 7F0CEB10"
end

template "/etc/apt/sources.list.d/mongodb.list" do
  mode 0644
end

execute "update apt" do
  command "apt-get update"
  subscribes :run, resources(:template => "/etc/apt/sources.list.d/mongodb.list"), :immediately
  action :nothing
end
