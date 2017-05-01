#!/bin/bash

OCP_PROJECT=rhamt
APP=rhamt-web-console
APP_DIR=app
APP_EAR=${APP_DIR}/rhamt.ear

# Checks if the "rhamt.ear" file has been added properly
ls -al ${APP_EAR}
rc=$?; if [[ $rc != 0 ]]; then echo "Missing deployment. Please build and copy to the application to ${APP_EAR}"; exit $rc; fi

echo
echo "Openshift project"
echo "  -> Create Openshift project (${OCP_PROJECT})"
oc login 10.1.2.2:8443 --username=openshift-dev --password=devel 2>&1 > /dev/null
oc new-project ${OCP_PROJECT} 2>/dev/null > /dev/null
sleep 1

echo "  -> Switch to project"
oc project ${OCP_PROJECT}  2>&1 > /dev/null

echo
echo "Project setup"

# Templates taken from https://github.com/jboss-openshift/application-templates/tree/master/secrets
echo "  -> Populate EAP and SSO secrets"
oc create -n ${OCP_PROJECT} -f templates/eap-app-secret.json
sleep 1
oc create -n ${OCP_PROJECT} -f templates/sso-app-secret.json
sleep 1

echo "  -> Process template"
# Template adapted from https://github.com/jboss-openshift/application-templates/blob/master/eap/eap70-postgresql-persistent-s2i.json
oc process -f templates/rhamt-template.json | oc create -n ${OCP_PROJECT} -f -
sleep 1

echo
echo "Build images"

echo "  -> Build 'eap-builder' image"
oc start-build --wait --from-dir=builder eap-builder

echo "  -> Build '${APP}' application image"
oc start-build --wait --from-dir=${APP_DIR} ${APP} 2>/dev/null > /dev/null

echo
echo "Start application (${APP})"

oc new-app -e JAVA_HOME=/usr/lib/jvm/java-1.8.0 ${APP}  2>/dev/null > /dev/null
