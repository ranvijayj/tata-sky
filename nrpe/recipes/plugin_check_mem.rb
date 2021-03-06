#
# Cookbook Name:: nrpe
# Recipe:: plugin_check_mem.pl
#
# Copyright 2014, Virender Khatri
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

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_mem.pl') do
  source 'https://raw.githubusercontent.com/justintime/nagios-plugins/master/check_mem/check_mem.pl'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  action :create_if_missing
  only_if { node['nrpe']['manage'] }
end
