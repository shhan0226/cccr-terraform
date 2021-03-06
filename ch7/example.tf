provider "openstack" {
  user_name   = "user"
  tenant_name = "cccr"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}


resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_name      = "centos7"
  flavor_name     = "flavor1"
  key_pair        = "cccr-key"
  security_groups = ["default", "cccr-sg"]
  network {
    name = "private1"
  }
  depends_on = [openstack_networking_floatingip_v2.fip1]
}


resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "external"
}

resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip 	= "${openstack_networking_floatingip_v2.fip1.address}"
  instance_id   = "${openstack_compute_instance_v2.vm1.id}"
}

