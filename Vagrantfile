# encoding: utf-8
#
# CoreOS jekyll/docker

$image_version = "current"
$update_channel='alpha'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Encoding.default_external = 'UTF-8'

  config.vm.box = "coreos-%s" % $update_channel
  if $image_version != "current"
    config.vm.box_version = $image_version
  end
  config.vm.box_url = "https://storage.googleapis.com/%s.release.core-os.net/amd64-usr/%s/coreos_production_vagrant.json" % [$update_channel, $image_version]

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.hostname = "jekyll.boot.local"
  config.vm.network :private_network, ip: "192.168.98.10"

  # ssh-agentでホストOSのsshキーを共有
  config.ssh.forward_agent = true

  # 共有フォルダ
  config.vm.synced_folder ".", "/vagrant", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp']

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
    # ホストOSでVPNで接続したときのゲストOS側のDNSをホストOSのものを使うようにする
    #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    #vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # jekyll_bootの実行環境
  config.vm.provision "shell", 
    inline: "/vagrant/setup/vagrant/install-jekyll_boot.sh"
  # jekyll_bootコンテナの起動
  config.vm.provision "shell", 
    run: "always", 
    inline: "/vagrant/setup/vagrant/autoexec.sh"

end
