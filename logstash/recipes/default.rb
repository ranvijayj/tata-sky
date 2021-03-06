execute 'wgetlogstash' do
  command 'wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
  user "root"
end
#line=deb https://packages.elastic.co/logstash/2.3/debian stable main
#ruby_block "insert_line" do
#  block do
#    file = Chef::Util::FileEdit.new("/etc/apt/sources.list")
#    file.insert_line_if_no_match("/#{line}/", "#{line}")
#    file.write_file
#  end
#end

#Insert into apt source list
bash "insert_line" do
  user "root"
  code <<-EOS
  echo "deb https://packages.elastic.co/logstash/2.3/debian stable main" >> /etc/apt/sources.list
  EOS
  not_if "grep -q https://packages.elastic.co/logstash/2.3/debian stable main  /etc/apt/sources.list"
end

execute 'aptupdate' do
  command 'apt-get update'
  user "root"
end

package ['openjdk-7-jre', 'openjdk-7-jdk']

ruby_block 'set-env-java-home' do
  block do
    ENV['JAVA_HOME'] = "/usr/lib/jvm/java-1.7.0-openjdk-amd64"
  end
end


execute 'aptupdate' do
  command 'apt-get update'
  user "root"
end


apt_package 'logstash' do
  action :install
end

cookbook_file '/etc/logstash/conf.d/logstash.conf' do
       owner 'root'
       source 'logstash.conf.l2'
end

cookbook_file '/etc/init.d/logstash' do
       owner 'root'
       source 'logstashinit'
end


service "logstash" do
  action :stop
end

#execute 'changepersmissions' do
#  command 'chmod 644 /var/log/nginx/*'
#end

#directory '/var/log/nginx/' do
#  mode '0644'
#  action :create
#end


execute 'startlogstatsh' do
  command 'service logstash start'
  only_if '/opt/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf --configtest'
end
