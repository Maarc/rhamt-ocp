#!/bin/bash

mkdir -p ${JBOSS_HOME}/standalone/log

echo ">>> CLI" >> ${JBOSS_HOME}/standalone/log/inj.log

# Run our CLI script
${JBOSS_HOME}/bin/jboss-cli.sh --file=${JBOSS_HOME}/standalone/configuration/eap.cli >>${JBOSS_HOME}/standalone/log/inj.log 2>&1

echo "<<< CLI" >> ${JBOSS_HOME}/standalone/log/inj.log
