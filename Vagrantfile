# -*- mode: ruby -*-
# vi: set ft=ruby :

$wait = <<SCRIPT
echo "Waiting for docker sock file"
while [ ! -S /var/run/docker.sock ]; do
  sleep 1
done
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box     = "nanobox/boot2docker"
  config.vm.box_url = "https://github.com/pagodabox/nanobox-boot2docker/releases/download/v0.0.0/nanobox-boot2docker.box"

  config.vm.synced_folder ".", "/vagrant"

  # wait for docker to be running
  config.vm.provision "shell", inline: $wait

  # Add docker credentials
  config.vm.provision "file", source: "~/.dockercfg", destination: "/root/.dockercfg"

  # Build pre-build image
  config.vm.provision "shell", inline: "docker build -t #{ENV['docker_user']}/pre-build /vagrant/pre-build"

  # Build build image
  config.vm.provision "shell", inline: "docker build -t #{ENV['docker_user']}/build /vagrant"

  # Publish images to dockerhub
  config.vm.provision "shell", inline: "docker push #{ENV['docker_user']}/build"
  config.vm.provision "shell", inline: "docker push #{ENV['docker_user']}/pre-build"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

end
