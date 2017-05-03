#!/bin/bash

mkdir -p ${JBOSS_HOME}/standalone/log

echo ">>> CLI" >> ${JBOSS_HOME}/standalone/log/inj.log

# Run our CLI script
${JBOSS_HOME}/bin/jboss-cli.sh --file=${JBOSS_HOME}/standalone/configuration/eap.cli 2>>${JBOSS_HOME}/standalone/log/inj.log >>${JBOSS_HOME}/standalone/log/inj.log

echo "<<< CLI" >> ${JBOSS_HOME}/standalone/log/inj.log
