# oracle-builder

FROM openshift/base-centos7

EXPOSE 1521

RUN yum update && \
    INSTALL_PKGS="bc net-tools wget sudo unzip" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    wget 'https://www.googledrive.com/host/0B8Ullq6_B51jM3ZTdDFBWmNmX2s' -O oracle-xe-11.2.0-1.0.x86_64.rpm.zip  && \ 
    unzip oracle-xe-11.2.0-1.0.x86_64.rpm.zip && \
    yum install -y ./Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm && \
    yum clean all -y

RUN cp /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora.tmpl && \    
    mv /init-conf/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts && \
    mv /init-conf/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts && \
    printf 8080\\n1521\\npotpass\\npotpass\\ny\\n | /etc/init.d/oracle-xe configure && \
    echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc && \
    mv /init-conf/startup.sh /usr/sbin/startup.sh && \
	chmod -R go+rw  /usr/sbin/startup.sh 

RUN echo "oracle ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers
#USER oracle

#CMD /usr/sbin/startup.sh
