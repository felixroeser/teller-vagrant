# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  options = {base_ip: '10.2.0.100'}

  config.vm.hostname = 'teller'

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048, "--cpus", 2]
  end

  config.vm.network :private_network, ip: options[:base_ip]

  [3000, 9292, 6379].each do |port|
    config.vm.network :forwarded_port, guest: port, host: port
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.synced_folder ".", "/vagrant", nfs: true, id: 'vagrant-root'

  config.ssh.username = 'vagrant'

  # config.berkshelf.enabled = true
  config.omnibus.chef_version = "11.4.4"
  config.vm.provision :chef_solo do |chef|

    # chef.add_recipe("ufw")
    chef.add_recipe("apt")
    chef.add_recipe("build-essential")
    chef.add_recipe("support")
    # chef.add_recipe("nginx::default")
    # chef.add_recipe("nginx::apps")
    chef.add_recipe("ruby_build")
    chef.add_recipe("rbenv::user")
    chef.add_recipe("rbenv::vagrant")
    chef.add_recipe("nodejs")
    chef.add_recipe("nodejs::npm")
    chef.add_recipe("redisio::install")
    chef.add_recipe("redisio::enable")
    chef.add_recipe("memcached")
    chef.add_recipe("postgresql")
    chef.add_recipe("postgresql::contrib")
    chef.add_recipe("postgresql::client")
    chef.add_recipe("postgresql::server")
    chef.add_recipe("postgresql::libpq")

    chef.json = {
      'nodejs' => { 'version' => '0.10.12'},
      'rbenv' =>  {
        "user_installs" => [
          { 'user' => 'vagrant',
            'rubies'  => ['2.0.0-p247'],
            'global'  => '2.0.0-p247',
            'gems' => {
              '2.0.0-p0' => [
                {'name' => 'bundler'},
                {'name' => 'puma' },
                {'name' => 'forward' },
                {'name' => 'thor'},
                {'name' => 'pry'},
                {'name' => 'zeus'},
                {'name' => 'foreman'}
              ]
            }
          }
        ]
      },
      'postgresql' => {
        'version' => '9.2',
        'users' => [
          {
            "username" => 'teller',
            "password" => 'test123',
            "superuser" => true,
            "createdb" => true,
            "login" => true
          }
        ],
        'databases' => [
          {
            "name" => "tellerapp_development",
            "owner" => "teller",
            "template" => "template0",
            "encoding" => "utf8",
            "locale" => "en_US.UTF8",
            "extensions" => ["hstore"]
          },
          {
            "name" => "tellerapp_test",
            "owner" => "teller",
            "template" => "template0",
            "encoding" => "utf8",
            "locale" => "en_US.UTF8",
            "extensions" => ["hstore"]
          }
        ]
      },
      'memcached' => {
        'memory' => 32,
        'listen' => '127.0.0.1'
      },
      'redisio' => {
        'version' => '2.6.16',
        'default_settings' => {
          'address' => '127.0.0.1',
        }
      },
      'nginx' => {
        :install_method => 'package',
        :gzip => 'on'
      },
      "firewall" => {
        "rules" => [
          {"http" => { "port" => "80" } },
          {"http" => { "port" => "3000" } }
        ]
      }
    }
  end
end
