Terraform script for provisioning EC2 instance with 

* graphical Xubuntu environment
* both *X2Go* and *NoMachine* remote desktop servers
* Firefox, Google Chrome, and other extras

useful for *very* private browsing, totally not at work.

Run `terraform apply`, then connect with X2Go/NoMachine client (user `ubuntu`, ports 22/4000) using IP printed back at the end. There is also manual bash script for Digital Ocean cloud.  The idea behind this complicated setup is 0 costs when not used, that's why everything is reprovisioned from scratch every time. 
