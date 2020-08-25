#!/bin/sh

adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date "+%Y-%m-%d %H:%M:%S")" "$line";
    done
}

export EAP_HOME="/opt/rh/eap7/root/usr/share/wildfly"
export EAP_RPM_CONF_STANDALONE="/etc/opt/rh/eap7/wildfly/eap7-standalone.conf"

JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2

/bin/date +%H:%M:%S >> eap.log
echo "Configuring JBoss EAP management user" | adddate >> eap.log
echo "$EAP_HOME/bin/add-user.sh -u JBOSS_EAP_USER -p JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'" | adddate >> eap.log
$EAP_HOME/bin/add-user.sh -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> eap.log 2>&1
flag=$?; if [ $flag != 0 ] ; then echo  "ERROR! JBoss EAP management user configuration Failed" | adddate >> eap.log; exit $flag;  fi 

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "ALL DONE!" | adddate >> eap.log
/bin/date +%H:%M:%S >> eap.log