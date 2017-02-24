FROM localhost:5000/centos-base
MAINTAINER Jason Zou<jason.zou@gmail.com>

LABEL ca.lakeheadu.library.generator="archivematica-lul"
LABEL vcs-ref="centos-archivematics"

ENV ARCH_VERSION 1.5.1
ENV ARCH_USER archivematica
ENV ARCH_PASSWD archivematica
ENV ARCH_DASHBOARD_USER archivematicadashboard
ENV ARCH_DASHBOARD_PASSWD archivematica


# system update
RUN yum install -y deltarpm epel-release

# add archivematica repo
COPY files/archivematica.repo /etc/yum.repos.d/archivemetica.repo

# install service dependencies
RUN yum install -y java-1.8.0-openjdk-headless gearmand && \
    systemctl enable gearmand.service 

# install Archivematica Storage Service
RUN yum install -y python-pip archivematica-storage-service

# Run some tasks as an archivematica user
COPY files/install.sh /install.sh
RUN su - archivematica && \
    set -a -e -x && \
    source /etc/sysconfig/archivematica-storage-service && \
    cd /usr/share/archivematica/storage-service && \
    /usr/lib/python2.7/archivematica/storage-service/bin/python manage.py migrate && \
    /usr/lib/python2.7/archivematica/storage-service/bin/python manage.py collectstatic --noinput


# enable storage service
#RUN systemctl enable archivematica-storage-service 
RUN yum install -y nginx
RUN systemctl enable nginx

COPY files/arch-extra.repo /etc/yum.repos.d/archivemetica-extras.repo

# install dashboard and mcp server
RUN yum install -y archivematica-common archivematica-mcp-server archivematica-dashboard
COPY files/archivematica-* /etc/sysconfig/
COPY files/archivematica/MCPServer/serverConfig.conf /etc/archivematica/MCPServer/serverConfig.conf
COPY files/archivematica/archivematicaCommon/dbsettings /etc/archivematica/archivematicaCommon/dbsettings

#RUN su - archivematica && \
#    set -a -e -x && \
#    source /etc/sysconfig/archivematica-dashboard && \
#    cd /usr/share/archivematica/dashboard && \
#    /usr/lib/python2.7/archivematica/dashboard/bin/python manage.py syncdb --noinput

# install mcp client
RUN rpm -Uvh https://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
    rpm -Uvh https://forensics.cert.org/cert-forensics-tools-release-el7.rpm
RUN yum install -y archivematica-mcp-client python-django
RUN yum install -y vim iftop nmap postfix tree
COPY files/archivematica/MCPClient/clientConfig.conf /etc/archivematica/MCPClient/clientConfig.conf

# fix files permission 
RUN chown archivematica:archivematica -R /var/archivematica/
    
# Copy ATOM Nginx config file
COPY files/default.conf /nginx.conf
COPY files/*.sh /

RUN cp /usr/bin/clamscan /usr/bin/clamdscan
RUN ln -s /usr/bin/7za /usr/bin/7z
RUN systemctl enable archivematica-mcp-client
RUN systemctl enable archivematica-mcp-server
RUN systemctl enable archivematica-dashboard
RUN systemctl enable archivematica-storage-service
RUN systemctl enable postfix
RUN systemctl enable fits-nailgun

# install ssh server
RUN yum install -y openssh openssh-server rsync && \
    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    echo "root:passwd" | chpasswd 

RUN systemctl enable sshd
RUN chmod a+x /*.sh
RUN chown archivematica:archivematica -R /var/log/archivematica/

# add user archivematica into sudoers
RUN echo "archivematica        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers


ENTRYPOINT ["/usr/sbin/init"]

# expose ssh port 
EXPOSE 22 8001 81

VOLUME /home
#CMD python
