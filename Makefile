
vagrant:
	@vagrant up
	@vagrant ssh -c "sudo bash /vagrant/scripts/configure-pxe-server.sh"
	@echo "=====> Completed pxe vagrant server"
	@vagrant ssh -c "sudo bash /vagrant/scripts/create-iso.sh"

clean:
	vagrant destroy -f
