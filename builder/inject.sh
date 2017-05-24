#!/bin/bash

mkdir -p ${JBOSS_HOME}/standalone/log


echo ">>> SSO" >> ${JBOSS_HOME}/standalone/log/inj.log

java -jar ${JBOSS_HOME}/standalone/configuration/windup-keycloak-tool.jar create-windup-realm --keycloakUrl http://sso:8080/auth --username admin --password admin --keycloakVersion sso_70 >> ${JBOSS_HOME}/standalone/log/inj.log
java -jar ${JBOSS_HOME}/standalone/configuration/windup-keycloak-tool.jar create-windup-user --newUserID rhamt --newUserPassword password --firstName rhamt --lastName rhamt --keycloakUrl http://sso:8080/auth --username admin --password admin

echo "<<< SSO" >> ${JBOSS_HOME}/standalone/log/inj.log



echo ">>> CLI" >> ${JBOSS_HOME}/standalone/log/inj.log

# Run our CLI script
${JBOSS_HOME}/bin/jboss-cli.sh --file=${JBOSS_HOME}/standalone/configuration/eap.cli >>${JBOSS_HOME}/standalone/log/inj.log 2>&1

echo "<<< CLI" >> ${JBOSS_HOME}/standalone/log/inj.log
