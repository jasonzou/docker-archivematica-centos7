su - archivematica
set -a -e -x
source /etc/sysconfig/archivematica-dashboard
cd /usr/share/archivematica/dashboard
/usr/lib/python2.7/archivematica/dashboard/bin/python manage.py syncdb --noinput
