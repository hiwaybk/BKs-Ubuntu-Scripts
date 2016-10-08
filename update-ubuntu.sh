#!/bin/sh

REBOOT_TIME=4:00

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

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __prompt_user
#   DESCRIPTION:  Prompt the user for input
#    PARAMETERS:  Prompt to display to user
#       RETURNS:  User input
#-------------------------------------------------------------------------------
__prompt_user() {
	VAR="${1}"
	PROMPT="${2}"
	DEFAULT="${3}"

    echo -n "${PROMPT}"
    if [ "${DEFAULT}" ]; then
	    echo -n " [${DEFAULT}]"
    fi
    echo -n ": "
    read ANSWER

	if [ "${ANSWER}" ]; then
	    eval "$VAR='${ANSWER}'"
	else
	    eval "$VAR='${DEFAULT}'"
	fi

}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __do_reboot
#   DESCRIPTION:  Schedule system reboot
#    PARAMETERS:  Time to reboot
#       RETURNS:  Nothing
#-------------------------------------------------------------------------------
__do_reboot() {
	TIME="${1}"

	TMP=/tmp/rebootScript

	echo '#!/bin/sh -x' > "${TMP}"
	echo '' >> "${TMP}"
	echo 'sudo shutdown -r '"${TIME}"' "Scheduled reboot"' >> "${TMP}"

	chmod a+x "${TMP}"

	screen -c /dev/null -S Reboot -t Reboot -d -m "${TMP}"

	sleep 3

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
			echo ""
			echo "Updating $HOSTNAME"
			echo "Updating $HOSTNAME" | tr -c '[ \n]' '-'
			echo ""

			sudo apt-get dist-upgrade \
			&& sudo apt-get autoremove \
			|| die 1 "Update failed."

			echo ""
			echo "$HOSTNAME Update Complete"
			echo "$HOSTNAME Update Complete" | tr -c '[ \n]' '-'
			echo ""

			test -x /etc/update-motd.d/98-fsck-at-reboot \
			&& sudo /etc/update-motd.d/98-fsck-at-reboot

            REBOOT_SCHEDULED=`ps -ef | grep -i shutdown | grep 'Scheduled reboot' | wc -l`

            test "${REBOOT_SCHEDULED}" -lt 1 \
            && test -x /etc/update-motd.d/98-reboot-required \
            && REBOOT_NEEDED=`sudo /etc/update-motd.d/98-reboot-required` \
            && echo "${REBOOT_NEEDED}"

			if [ `echo "${REBOOT_NEEDED}" | grep 'System restart required' | wc -l` -gt 0 ]; then
				__prompt_user DO_REBOOT "Schedule reboot?" "Yes"
				DO_REBOOT=`echo "${DO_REBOOT}" | cut -c-1 | tr 'y' 'Y'`
				if [ "${DO_REBOOT}" = "Y" ]; then
					echo "Current time is" `date`
					__prompt_user REBOOT_TIME "Reboot time?" "${REBOOT_TIME}"
					__do_reboot "${REBOOT_TIME}"
				fi
			fi

		else
			echo ""
			echo "Updating remote host $HOST"
			echo "Updating remote host $HOST" | tr -c '[ \n]' '-'
			echo ""

			#ssh $HOST hostname
			ssh -t $HOST `basename $0`
		fi
		echo ""
	done
done



exit 0



