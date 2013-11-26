# (From cookbooks/MY_COOCKBOOK/recipes/default.rb)
# Install required packages
%w{mc htop libncurses5-dev openssl libssl-dev libsasl2-dev screen imagemagick libmagickwand-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# Download and extract static compiled ffmpeg
src_filepath = "/opt/ffmpeg_static.tar"
src_shasum = '28aacee782a6b08d41d15269dae3a0aa70e4930d'

remote_file src_filepath do
  source "http://ffmpeg.gusari.org/static/64bit/ffmpeg.static.64bit.2013-07-31.tar.gz"
  checksum src_shasum
  owner 'root'
  group 'root'
  mode 00644
end

bash 'extract_module' do
  code <<-EOH
    tar xzf #{src_filepath} -C /usr/local/bin
    EOH
  not_if { ::File.exists?("/usr/local/bin/ffmpeg") && `shasum #{src_filepath}`.split(' ').first == src_shasum }
end
