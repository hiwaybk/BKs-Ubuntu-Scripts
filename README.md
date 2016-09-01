# BKs-Ubuntu-Scripts
<!--- Project=BKs-Ubuntu-Scripts --->
<!--- MajorVersion=0 --->
<!--- MinorVersion=2 --->
<!--- PackageVersion=1 --->
<!--- MaintainerName="Brian Kelly" --->
<!--- MaintainerEmail=Github@Brian.Kelly.name --->
<!--- Depends="perl (>= 5.14.2), mdadm (>= 3.2.5), lvm2 (>= 2.02.66)" --->
<!--- Description="Various utility scripts for managing an Ubuntu Linux system" --->

Scripts for managing LVM volumes on software RAID

> This is my collection of scripts for managing my Ubuntu Linux systems

```
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
* Version 0.2
  1. Added prompts to schedule reboot if necessary
* Version 0.1
  1. Created initial package with update-ubuntu.sh and package maintenance scripts

--[Brian Kelly](https://github.com/hiwaybk)
