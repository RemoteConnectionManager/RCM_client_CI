# RCM client OSX build environment

### This folders conains some instruction to setup an OSX platform to be used by Jenkins CI

As the phisycal hardware ( macmini ) has been placed under a protected network that can not be reached from jenkins master,
we have relied on a reverse ssh tunnel on port 22000 from macmini to jenkins node so to let scripts to ssh into localhost -p 22000 as
macmini user

this is done by the command:
ssh -N -R 22000:localhost:22 ubuntu@130.186.13.241

In order to make it persistent across reboot, the file:
com.launchd.jenkinsreversetunnel.plist

has to be copied into 
/Library/LaunchAgents

To create plist....

sudo /usr/libexec/PlistBuddy /Library/LaunchAgents/com.launchd.jenkinsreversetunnel.plist -c "add Label string com.launchd.jenkinsreversetunnel" -c "add ProgramArguments array" -c "add ProgramArguments: string ssh" -c "add ProgramArguments: string -N" -c "add ProgramArguments: string -R" -c "add ProgramArguments: string 22000:localhost:22" -c "add ProgramArguments: string ubuntu@130.186.13.241" -c "add RunAtLoad bool true" -c "add UserName string rcm"


