terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.206.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
    ansible = {
      source = "ansible/ansible"
      version = "1.1.0"
    }

  }
}

provider "alicloud" {
  access_key = "LTAI5tG84zkQnVxu6y5Ks4vr"
  secret_key = "xjvrtF7pNfrRKotng4Dn97FymasFzD"
  region     = "cn-hangzhou"
}

# provider "alicloud" {
#   access_key = "LTAI5t5da5kSEF8XqSrkH5vt"
#   secret_key = "nR07v0aiKH2fJxurn1mPQgN8NQyTgG"
#   region     = "cn-hangzhou"
# }

resource "alicloud_instance" "name" {
  image_id = "centos_7_9_x64_20G_alibase_20230516.vhd"
  security_groups = [
              "sg-bp181hhphvhyu0wchlj4"
            ]
  instance_type = "ecs.t6-c2m1.large" 
  instance_name= "terraform-launch-test1"
  internet_max_bandwidth_out= 5 
  vswitch_id= "vsw-bp117ga2xk1dyfakk5vqg" 
  #auto_release_time= "2023-08-30T08:59Z"     
  internet_charge_type= "PayByTraffic"
  maintenance_notify= false
  spot_price_limit= 0
  system_disk_encrypted= false
  tags= {}
  system_disk_category= "cloud_essd"
  spot_strategy= "SpotAsPriceGo"
}

# resource "alicloud_security_group" "default" {
#   description= "System created security group."
#   name= "sg-bp181hhphvhyu0wchlj4"
#   vpc_id= "vpc-bp1gwingbl280gcimiw1y"
#   tags= {}
# }

resource "local_file" "inventory" {
  content = alicloud_instance.name.public_ip
  filename = "${path.module}/ansible/inventory"
}

resource "null_resource" "ansible_local_test" {
  
}

resource "ansible_host" "host" {
  name = alicloud_instance.name.public_ip
}

# resource "ansible_playbook" "playbook" {
#   playbook = "${path.module}/ansible/hello.yaml"
#   name = ansible_host.host.name
# }

output "instance_id" {
  value= alicloud_instance.name.id
}

output "instance_public_ip" {
  value= alicloud_instance.name.public_ip
}

output "instance_name" {
  value= alicloud_instance.name.instance_name
}

output "spot_strategy" {
  value= alicloud_instance.name.spot_strategy
}

# output "instance_release_time" {
#   value= alicloud_instance.name.auto_release_time
# }



