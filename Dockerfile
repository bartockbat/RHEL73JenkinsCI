FROM registry.access.redhat.com/rhel7

LABEL name="" \
      vendor="" \
      version="" \
      release="" \
      summary="" \
      description="....." \
### Required labels above - recommended below
      url="" \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="" \
      io.k8s.display-name="" \
      io.openshift.expose-services="" \
      io.openshift.tags=""


COPY help.1 /tmp/
RUN mkdir -p /licenses
COPY licenses /licenses

#Adding EPEL Repo for software - pure-ftpd
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms rhel-7-server-ose-3.5-rpms \
### Add your package needs here
    INSTALL_PKGS="docker jre jenkins git atomic-openshift-clients-3.5.5.31-1.git.0.b6f55a2.el7.x86_64" && \
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all
 
EXPOSE 8080

ENTRYPOINT ["/usr/bin/java","-jar","/usr/lib/jenkins/jenkins.war"]
