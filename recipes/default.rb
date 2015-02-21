#
# Cookbook Name:: postfix-dkim
# Recipe:: default
#
# Copyright 2011, Room 118 Solutions, Inc.
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

package 'opendkim'

template "/etc/opendkim.conf" do
  notifies :restart, "service[opendkim]"
  source "opendkim.conf.erb"
  mode 0755
end

template "/etc/default/opendkim" do
  notifies :restart, "service[opendkim]"
  source "opendkim.erb"
  mode 0755
end

directory File.dirname(node[:postfix_dkim][:keyfile]) do
  mode 0755
end

execute "generate and install key" do
  cwd File.dirname(node[:postfix_dkim][:keyfile])
  not_if { File.exist?(node[:postfix_dkim][:keyfile]) }
  command <<-EOH
    opendkim-genkey #{node[:postfix_dkim][:testmode] ? '-t' : ''} -s #{node[:postfix_dkim][:selector]} -d #{node[:postfix_dkim][:domain]}
    mv "#{node[:postfix_dkim][:selector]}.private" #{File.basename node[:postfix_dkim][:keyfile]}
  EOH
end

file node[:postfix_dkim][:keyfile] do
  owner "opendkim"
  group "opendkim"
  mode 0400
  action :create
end

group "opendkim" do
  action :modify
  members "postfix"
  append true
end

service "opendkim" do
  supports status: true, restart: true
  action :enable
end
