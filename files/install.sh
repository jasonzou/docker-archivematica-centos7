su - archivematica
set -a -e -x
source /etc/sysconfig/archivematica-storage-service
cd /usr/share/archivematica/storage-service
/usr/lib/python2.7/archivematica/storage-service/bin/python manage.py migrate
/usr/lib/python2.7/archivematica/storage-service/bin/python manage.py collectstatic --noinput
