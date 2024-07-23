Vagrant.configure(2) do |config|
    [
        ["git.myusine.fr", "2048", "2", "debian/wormbook64"],
    ].each do |vmname,mem,cpu,os|
        config.vm.define "#{vmname}" do |machine|

        machine.vm.provider "virtualbox" do |v|
            v.memory = "#{mem}"
            v.cpus = "#{cpu}"
            v.name = "#{vmname}"
            v.customize ["modifyvm", :id, "--ioapic", "on"]
            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end
        machine.vm.box = "#{os}"
        machine.vm.hostname = "#{vmname}"
        machine.vm.network "public_network"
        end
    end
end