# Synchronous Replication, Performance and Advanced Behaviours

## Get some base numbers

Run a first `pgbench` test:

	$ /usr/lib/postgresql/9.2/bin/pgbench -c 1 -T 10

## Set up sync rep

	/sudo::/etc/postgresql/9.2/main/postgresql.conf
	=# select pg_reload_conf();
	=# show synchronous_standby_names;
	=# select * from pg_stat_replication;

## Show pgbench running, with sync rep

	$ /usr/lib/postgresql/9.2/bin/pgbench -c 1 -T 10

## Monitoring sync rep

Let's have a look at `munin` graphs.

## Show hot standby conflict

Launch a long running query on the *standby*, and see what happens.

	=# select pg_sleep(60);
	
On some other shell:

	$ sudo tail -f /var/log/postgresql/postgresql-9.2-standby.log

Now on the master:

	=# create table foo as select x, x*2 from generate_series(1, 10000) as t(x);
	=# vacuum;

## Fix hot standby conflict

Edit the setup

    /sudo::/etc/postgresql/9.2/main/postgresql.conf
	$ sudo pg_ctlcluster 9.2 main reload
	=# show hot_standby_feedback;

Redo the test.

## Show how to modify app to have mixed mode durability and regain performance

So, we can set `synchronous_commit` *per transaction*. Let's try that.

Edit the configuration to add a new parameter, demo.threshold.

   	/sudo::/etc/postgresql/9.2/main/postgresql.conf
	$ sudo pg_ctlcluster 9.2 main reload

Run a first `pgbench` test, always sync:

	$ /usr/lib/postgresql/9.2/bin/pgbench -c 1 -T 10

On of the things that `pgbench` does is:

	\setrandom delta -5000 5000
	UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;

So let's create a trigger on pgbench_accounts that will change the
`synchronous_commit` on the fly for only the current transaction only when
`delta > 100` and see what we get.

	=# \i ~/dev/pgconfs/pgday_2012/replication-training/pgbench-trigger.sql
	$ /usr/lib/postgresql/9.2/bin/pgbench -c 1 -T 10

Now let's disable the trigger and see what happens

	=# alter table pgbench_accounts disable trigger syncrep_important_delta;
	$ /usr/lib/postgresql/9.2/bin/pgbench -c 1 -T 10

## Pause/Resume and DDL changes

### Basic demo of pause and resume

Let's see those functions:

	=# \df *pg_xlog_replay*

First test, let's pause the *standby* and make some changes on the primary.

Pause the *standby*:

	=# select pg_xlog_replay_pause();
	=# select pg_is_xlog_replay_paused();
	
Do something on the *master*:

	=# create table test(id serial primary key, f1 text);
	=# select * from pg_stat_replication;
	=# \dt+ test

On the *standby*, display the table, resume the recovery, display the table
again:

	=# \dt+ test
	=# select pg_xlog_replay_resume();
	=# select pg_is_xlog_replay_paused();

*master*

	=# select * from pg_stat_replication;

*standby* again:

	=# \dt+ test
	=# \d test

### Pause, Resume, and locks

Let's pause the *standby* again:

	=# select pg_xlog_replay_pause();
	=# select pg_is_xlog_replay_paused();

Now let's `lock` that `test` table we just created, on the *master*:

	=# begin;
	=# lock table test;
	=# alter table test add column f2 text;
	=# 

In another shell, connect to the *master* and try accessing the `test`
table:

	=# select * from test;

Back to the *standby*, is the table locked?

	=# select * from test;

Now let's unlock the *master*:

	=# commit;

And resume the *standby*:

	=# select pg_xlog_replay_resume();
	=# select pg_is_xlog_replay_paused();
