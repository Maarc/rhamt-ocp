FROM jboss-eap-7/eap70-openshift:1.4

# Backup
RUN cp /opt/eap/bin/openshift-launch.sh /opt/eap/bin/openshift-launch.sh.orig

# Remove line containing "standalone.sh"
RUN cat /opt/eap/bin/openshift-launch.sh.orig |grep -v standalone.sh |grep -v jboss_modules_system_pkgs > /opt/eap/bin/openshift-launch.sh

# Run CLI script in offline mode
RUN echo 'source ${JBOSS_HOME}/bin/inject.sh' >> /opt/eap/bin/openshift-launch.sh

RUN echo 'JBOSS_MODULES_SYSTEM_PKGS=org.jboss.byteman' >> /opt/eap/bin/openshift-launch.sh

RUN sed -i -e 's#-Xbootclasspath/p:${JBOSS_MODULES_JAR}:${JBOSS_LOGMANAGER_JAR}:${JBOSS_LOGMANAGER_EXT_JAR}##g' /opt/eap/bin/standalone.conf
RUN sed -i -e 's#-Djava.util.logging.manager=org.jboss.logmanager.LogManager##g' /opt/eap/bin/standalone.conf
RUN sed -i -e 's#-javaagent:$JBOSS_HOME/jolokia.jar=port=8778,protocol=https,caCert=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt,clientPrincipal=cn=system:master-proxy,useSslClientAuthentication=true,extraClientCheck=true,host=0.0.0.0,discoveryEnabled=false##g' /opt/eap/bin/standalone.conf


# Add updated "standalone.sh"
RUN echo 'exec $JBOSS_HOME/bin/standalone.sh -c standalone-openshift.xml -bmanagement 127.0.0.1 $JBOSS_HA_ARGS ${JBOSS_MESSAGING_ARGS}' >> /opt/eap/bin/openshift-launch.sh

USER 0
RUN sed -i 's/cp -v /cp -av /' -- /usr/local/s2i/assemble
USER 185

ADD inject.sh /opt/eap/bin/
