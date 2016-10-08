# BKs-Ubuntu-Scripts
<!--- Project=BKs-Ubuntu-Scripts --->
<!--- MajorVersion=0 --->
<!--- MinorVersion=6 --->
<!--- PackageVersion=0 --->
<!--- MaintainerName="Brian Kelly" --->
<!--- MaintainerEmail=Github@Brian.Kelly.name --->
<!--- Depends="perl (>= 5.14.2), mdadm (>= 3.2.5), lvm2 (>= 2.02.66)" --->
<!--- Description="Various utility scripts for managing an Ubuntu Linux system" --->

Scripts for managing Ubuntu Linux system.

update-ubuntu.sh
----------------

This script will use `apt-get` to update and upgrade (`update`, `dist-upgrade`,
and `autoremove`) your system.  If the system requires a reboot, the script
will prompt the user to schedule one and at what time.

If the script is installed on multiple systems, and `ssh` keys are setup, the
main system can be used to initiate updates on all the others.  To activate this
mode, create a config file name `/etc/default/update-ubuntu` using the following
example:

```
REBOOT_TIME=4:00

UBUNTU_UPDATE_HOSTS_PASS_01="\
	chambers.mozart.hiwaybk.com \
	mtcs.mozart.hiwaybk.com \
	sullivan.mozart.hiwaybk.com \
"

UBUNTU_UPDATE_HOSTS_PASS_02="\
	prince.mozart.hiwaybk.com \
	manhattan.mozart.hiwaybk.com \
	trinity.mozart.hiwaybk.com \
"

UBUNTU_UPDATE_HOSTS_PASS_03="\
	king.montclair.edu \
"
```

# ChangeLog
* Version 0.6
  1. Changed the default response to "Yes" for the "Schedule reboot?" prompt
* Version 0.5
  1. Allowed the default REBOOT_TIME for the scheduled reboot promt to be set in `/etc/default/update-ubuntu`
  2. Added a 3 second delay after scheduling a reboot with screen to allow screen to detach properly
* Version 0.4
  1. Fixed error where scheduled reboot resulted in immediate reboot
  2. Updated package maintenace scripts
* Version 0.3
  1. Cleaned up output
* Version 0.2
  1. Added prompts to schedule reboot if necessary
* Version 0.1
  1. Created initial package with update-ubuntu.sh and package maintenance scripts

--[Brian Kelly](https://github.com/hiwaybk)
