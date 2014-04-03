create table mesures(
  date timestamptz primary key,
  mesure integer
);

create table measures(tick int, nb int);

insert into measures
     values (1, 0), (2, 10), (3, 20), (4, 30), (5, 40),
            (6, 0), (7, 20), (8, 30), (9, 60);

  select tick, nb, lead(nb) over (order by tick)
    from measures;

  select tick, nb,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
              else null
          end as max
    from measures
  window w as (order by tick);

with t(tick, nb, max) as (
  select tick, nb,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
              else null
          end as max
    from measures
  window w as (order by tick)
)
select tick, nb, max from t where max is not null;

with t(tops) as (
  select case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
              else null
          end as max
    from measures
  window w as (order by tick)
)
select sum(tops) from t;

insert into measures
     values (10, 0), (11, 10), (12, 30), (13, 35), (14, 45),
            (15, 25), (16, 50), (17, 100), (18, 110);

with t(tops) as (
   select case when lead(nb) over w < nb then nb
               when lead(nb) over w is null then nb
               else null
           end as max
     from measures
   window w as (order by tick)
)
select sum(tops) from t;

select array_agg(nb)
  from measures
 where tick >= 4 and tick < 14;

  select nb,
         first_value(nb) over w as first,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
              else null
          end as max
    from measures
   where tick >= 4 and tick < 14
  window w as (order by tick);

with t as (
  select tick,
         first_value(nb) over w as first,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
              else null
          end as max
    from measures
   where tick >= 4 and tick < 14
  window w as (order by tick)
)
select sum(max) - min(first) as sum
 from t;

select array_agg(nb) from measures where tick >= 4 and tick < 14;

with tops as (
  select tick, nb,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
             else null
         end as max
    from measures
  window w as (order by tick)
)
  select tick, nb, max,
         (select tick
            from tops t2
           where t2.tick >= t1.tick and max is not null
        order by t2.tick
           limit 1) as p
    from tops t1;



with tops as (
  select tick, nb,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
             else null
         end as max
    from measures
  window w as (order by tick)
),
     parts as (
  select tick, nb, max,
         (select tick
            from tops t2
           where t2.tick >= t1.tick and max is not null
        order by t2.tick
           limit 1) as p
    from tops t1
),
     ranges as (
  select first_value(tick) over w as start,
         last_value(tick) over w as end,
         max(max) over w
    from parts
  window w as (partition by p order by tick)
)
select * from ranges where max is not null;



with tops as (
  select tick, nb,
         case when lead(nb) over w < nb then nb
              when lead(nb) over w is null then nb
             else null
         end as max
    from measures
  window w as (order by tick)
),
     parts as (
  select tick, nb, max,
         (select tick
            from tops t2
           where t2.tick >= t1.tick and max is not null
        order by t2.tick
           limit 1) as p
    from tops t1
),
     ranges as (
  select int4range(first_value(tick) over w,
                   last_value(tick) over w,
                   '[]') as range,
         max(max) over w as compteur
    from parts
  window w as (partition by p order by tick)
)
select range, compteur
  from ranges
 where compteur is not null and range @> 11;

