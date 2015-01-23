docker-mininet
==============

Mininet with OpenFlow and OpenVSwitch from source in a Docker container. There are lots of mininet images around, none with public Dockerfiles. Ideally, I'll build this one with other controllers and functionality suitable for more than dabbling.

### Usage:

Pull or build the image.

	docker run --privileged=true -it --rm imcp9/mininet:ovs1.4.2

Run mininet with userspace vswitches.

	mn --switch user

Run ssh server(username/password: root/root)

	/usr/sbin/sshd -D
	
