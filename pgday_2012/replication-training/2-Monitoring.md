# Monitoring Streaming Replication

How to check that everything is going ok? What do you mean by ok?

## Monitoring basics

    =# \df *location*
	=# select pg_current_xlog_location();
	=# select pg_current_xlog_insert_location();

## Using the system's view

The system comes with `pg_stat_replication` to monitor replication:

    =# select * from pg_stat_replication;
	=# select pg_xlog_location_diff(sent_location, flush_location)
	     from pg_stat_replication;

## Monitoring

To get graphs, install munin on the server.

    $ sudo apt-get install munin libdbd-pg-perl
	$ sudo /usr/sbin/munin-node-configure --shell | sudo sh -

## Some Benchmark Testing

Let's use `pgbench` here:

     $ dpkg -L postgresql-contrib-9.2 | grep pgbench
	 $ /usr/lib/postgresql/9.2/bin/pgbench -i -s 10 -F 80

Check that all tables are here on the master and the standby

	=# \dt+
	
Now generate some activity with `pgbench`, and have a look at what happens
in the `pg_stat_replication` view.

	$ /usr/lib/postgresql/9.2/bin/pgbench -c 1 -T 20 
	=# SELECT * FROM pg_stat_replication;
	
Check the data:

	=# select sum(abalance) from pgbench_accounts;

