#
# Cookbook Name:: openresty
# Recipe:: default
#
# Copyright 2016, tashinfrus
#
# All rights reserved - Do Not Redistribute
#
openresty_install_dir=node[:openresty][:install_dir]

execute 'openresty_package_download' do
  command 'wget http://openresty.org/download/ngx_openresty-1.5.8.1.tar.gz'
  cwd '/opt/'
  not_if { File.exists?("/opt/ngx_openresty*") }
end
bash 'extract_openresty' do
  interpreter "bash"
  code <<-EOH
    tar -xzf /opt/ngx_openresty-1.5.8.1.tar.gz -C #{openresty_install_dir}
    rm -rf /opt/ngx_openresty-1.5.8.1.tar.gz
    mv #{openresty_install_dir}/ngx_openresty* #{openresty_install_dir}/ngx_openresty
    cd #{openresty_install_dir}/ngx_openresty
    ./configure --prefix=/opt/openresty --with-pcre-jit --with-pcre --with-http_ssl_module --with-luajit
    make
    make install
    cd /opt/openresty/nginx/sbin/
    ./nginx -c ../conf/nginx.conf
    ln -s /opt/openresty/nginx/conf /etc/nginx
    ./nginx -c conf/nginx.conf
    EOH
  only_if { ::File.exists?(openresty_install_dir) }
end
execute 'set-env' do
	command 'export PATH=$PATH:/opt/openresty/nginx/sbin'
end

