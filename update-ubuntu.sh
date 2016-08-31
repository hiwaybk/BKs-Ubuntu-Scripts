#!/bin/sh

# Source our config file, if it exists
CONFIGFILE="/etc/default/update-ubuntu"
[ -r "${CONFIGFILE}" ] && . "${CONFIGFILE}"

LOG=/tmp/`basename $0`-$$.tmp

trap 'rm "${LOG}"' 1 2 3 15

die() {
        RETVAL=$1; shift
        echo ""
        echo "${@}"
        echo ""
        exit "${RETVAL}"
}

HOSTNAME=`hostname | cut -d\. -f1`

HOSTVARS=`set | grep ^UBUNTU_UPDATE_HOSTS_PASS_ | cut -d= -f1`

if [ ! "${HOSTVARS}" ]; then
	UBUNTU_UPDATE_HOSTS_PASS_01="${HOSTNAME}"
	HOSTVARS="UBUNTU_UPDATE_HOSTS_PASS_01"
fi


for HOSTVAR in ${HOSTVARS}; do
	eval HOSTS=\$$HOSTVAR
	echo "Starting $HOSTVAR: $HOSTS"
	echo ""
	for HOST in ${HOSTS}; do
		if [ `echo "${HOST}" | cut -d\. -f1` = "${HOSTNAME}" ]; then
			echo "Updating local system"

			sudo apt-get dist-upgrade \
			&& sudo apt-get autoremove \
			|| die 1 "Update failed."

			test -x /etc/update-motd.d/98-fsck-at-reboot \
			&& sudo /etc/update-motd.d/98-fsck-at-reboot

			test -x /etc/update-motd.d/98-reboot-required \
			&& REBOOT_NEEDED=`sudo /etc/update-motd.d/98-reboot-required` \
			| tee "${LOG}"
			echo "${REBOOT_NEEDED}"

		else
			echo "Updating remote host $HOST"
			#ssh $HOST hostname
			ssh -t $HOST `basename $0`
		fi
		echo ""
	done
done



exit 0









if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
	:
else
	echo "'${0}' '${1}' '${2}' '${3}' '${4}'" | at now + 1 minute >/dev/null 2>&1
	exit 0 # die 1 "No networking; will retry in 1 minute."
fi

test "${APIKEY}" || die 1 "No API key read from /etc/default/ifttt_api_key"

test "${1}" && EVENT="${1}"
test "${2}" && V1="${2}"
test "${3}" && V2="${3}"
test "${4}" && V3="${4}"

test "${APIKEY}" || die 1 "No even specified on command line (or read from /etc/default/ifttt_api_key)"

# If we don't have values, set some defaults
test "${EVENT}" || EVENT="hostalert"
test "${V1}" || V1=`hostname`
test "${V2}" || V2=`date "+%Y-%m-%d"`
test "${V3}" || V3=`date "+%H:%M"`

# Compile the URL and JSON data
URL="https://maker.ifttt.com/trigger/${EVENT}/with/key/${APIKEY}"
JSON='{"value1":"'"${V1}"'","value2":"'"${V2}"'","value3":"'"${V3}"'"}'

# Fire!
curl --silent -X POST -H "Content-Type: application/json" -d "${JSON}" "${URL}" \
| grep -v "Congratulations! You've fired the ${EVENT} event"

