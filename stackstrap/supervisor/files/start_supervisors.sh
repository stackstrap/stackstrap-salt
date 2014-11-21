#!/bin/bash
#
# Custom supervisord start up script
#
# It looks through the /usr/local/etc/supervisor.d directory
# and will start an instance for each conf file it finds there
#

CONF_DIR=/usr/local/etc/supervisor.d
SUPERVISORD=/usr/local/bin/supervisord

[ ! -d $CONF_DIR ] && exit

for CONF in ${CONF_DIR}/*.conf; do
    $SUPERVISORD -c $CONF
done

# vim: set ft=bash ts=4 sw=4 et sts=4 :
