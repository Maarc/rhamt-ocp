FROM jboss-eap-7/eap70-openshift:1.4

# Backup
RUN cp /opt/eap/bin/openshift-launch.sh /opt/eap/bin/openshift-launch.sh.orig

# Remove line containing "standalone.sh"
RUN cat /opt/eap/bin/openshift-launch.sh.orig |grep -v standalone.sh > /opt/eap/bin/openshift-launch.sh

# Run CLI script in offline mode
RUN echo 'source ${JBOSS_HOME}/bin/inject.sh' >> /opt/eap/bin/openshift-launch.sh

# Add updated "standalone.sh"
RUN echo 'exec $JBOSS_HOME/bin/standalone.sh -P ${JBOSS_HOME}/standalone/configuration/eap.properties -c standalone-openshift.xml -bmanagement 127.0.0.1 $JBOSS_HA_ARGS ${JBOSS_MESSAGING_ARGS}' >> /opt/eap/bin/openshift-launch.sh

USER 0
RUN sed -i 's/cp -v /cp -av /' -- /usr/local/s2i/assemble
USER 185

ADD inject.sh /opt/eap/bin/
