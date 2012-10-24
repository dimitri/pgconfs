# Streaming Replication Demo

## Setup (debian)

Use the new `apt.postgresql.org` repository, still cooking, to get
PostgreSQL 9.2 in squeeze, don't forget to install the signing key:

    $ wget -O - http://atalia.postgresql.org/pgapt/ACCC4CF8.asc |sudo apt-key add -
    $ deb http://atalia.postgresql.org/pgapt/pub/repos/apt/ squeeze-pgdg main
    $ sudo apt-get install postgresql-9.2 postgresql-contrib-9.2

How to find the configuration files easily when you didn't install the
system or are not familiar with a particular distribution/OS:

    $ sudo su - postgres
	$ psql
    =# select name, setting from pg_settings where name ~ 'conf';
	=# select name, setting from pg_settings where name ~ 'file' and not name ~ 'ssl|log';
	
Setup basic authentication so that we can work locally (`trust` localhost,
grant replication connection). Watch for permissions and logs:

	$ sudo su - postgres
	$ psql
	=# create role streamer with login replication;

    $ sudo cp /etc/postgresql/9.2/main/pg_hba.conf /etc/postgresql/9.2/main/pg_hba.conf.orig
    /sudo::/etc/postgresql/9.2/main/pg_hba.conf
	$ sudo pg_ctlcluster 9.2 main reload
	$ sudo tail /var/log/postgresql/postgresql-9.2-main.log 
	$ psql -U postgres

Edit the `postgresql.conf` file so that replication client are allowed to
connect, and so that we have the right kind of WAL generated:

    /sudo::/etc/postgresql/9.2/main/postgresql.conf
	$ sudo pg_ctlcluster 9.2 main restart

## Clone the primary server

Now we have a cluster to play with, and we need to prepare a standby from
it:

    $ pg_lsclusters
	$ sudo pg_basebackup -v -P -Xs -D /var/lib/postgresql/9.2/standby -U postgres
	$ sudo cp /etc/postgresql/9.2/main/{postgresql,pg_hba,pg_ident}.conf /var/lib/postgresql/9.2/standby
	$ sudo chown -R postgres:postgres /var/lib/postgresql/9.2/standby
	$ sudo chown -R postgres:postgres /etc/postgresql/9.2/standby
	$ sudo chown -R postgres:postgres /var/log/postgresql/postgresql-9.2-standby.log

Make the standby a debian managed cluster, while at it, and edit its basic
setup:

    $ sudo pg_createcluster -d /var/lib/postgresql/9.2/standby 9.2 standby
	/sudo::/etc/postgresql/9.2/standby/postgresql.conf
	/sudo::/etc/postgresql/9.2/standby/pg_hba.conf
	$ pg_lsclusters

Don't start the standby now. It would **not** be a standby yet.

## Connection

Edit `recovery.conf` so that the standby stay in crash recovery mode and
connect to the master:

    /sudo::/var/lib/postgresql/9.2/standby2/recovery.conf
	$ sudo pg_ctlcluster 9.2 standby2 start
	$ sudo tail /var/log/postgresql/postgresql-9.2-standby.log
	$ pg_lsclusters

## Tests

First test is to be able to actually connect to the standby:

	$ psql --cluster 9.2/standby2 -U postgres
	=# select pg_is_in_recovery();
	
Let's create a database and some table in it on the master:

	$ createuser -U postgres -sdr dim
    $ createdb -U postgres -O dim dim
	$ psql

	
	$ psql --cluster 9.2/standby
	=# select * from foo;
	=# \d foo
		
Data and their definitions are flying through!

## Conclusion

It's simpler that it looks, we took the long way here, starting from scratch
and detailing each step as we go. What we did, really:

 1. install and setup PostgreSQL
 2. set primary for Streaming Replication and Hot Standby
 3. clone the primary and setup the clone as a Hot Standby
 4. start the standby, check that it connects to the primary
 5. basic tests.
