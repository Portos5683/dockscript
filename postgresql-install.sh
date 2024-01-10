#!/bin/bash
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum -y update
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install postgresql15-server postgresql15-contrib
psql -V
/usr/pgsql-15/bin/postgresql-15-setup initdb
systemctl enable --now postgresql-15
systemctl enable postgresql-15.service
systemctl start  postgresql-15.service
systemctl restart  postgresql-15.service
systemctl status  postgresql-15.service

