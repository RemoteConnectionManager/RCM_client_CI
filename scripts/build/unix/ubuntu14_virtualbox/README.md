# RCM client ubuntu14 osboxes in virtualbox build environment

### This folders conains some instruction to setup an ubuntu14 inside virtualbox platform to be used by Jenkins CI

As the ubuntu 14 VM is hosted by a PDL placed under a protected network that can not be reached from jenkins master,
we have relied on a reverse ssh tunnel on port 22001 from virtualbox to jenkins node so to let scripts to ssh into localhost -p 22001 as
osboxes user

this is done by the command:
ssh -N -R 22001:localhost:22 ubuntu@130.186.13.241

TODO:
Make it persistent at boot time of the VM
