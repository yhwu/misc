# s3
aws s3 mb s3://myclust
aws s3 sync s3://bucket/pjm2 .\bucket\ --exclude 'nov2016/*' --exclude 'share/*'


# troubleshooting connections, locks, etc
select * from pg_tables;
select * from pg_table_def;

select * from pg_catalog.pg_locks;
select * from pg_catalog.pg_stat_activity;

select * from stv_locks;
select * from stv_recents;
select * FROM stv_sessions;
select pg_terminate_backend(21803);
# https://stackoverflow.com/questions/19568027/redshift-drop-or-truncate-table-very-very-slow

# check running queries
select pid, user_name, starttime, query
from stv_recents
where status='Running';

# cancel query
cancel 11475;

# check error
SELECT query,
       SUBSTRING(filename,22,25) AS filename,
       line_number AS LINE,
       SUBSTRING(colname,0,12) AS COLUMN,
       TYPE,
       POSITION AS pos,
       SUBSTRING(raw_line,0,30) AS line_text,
       SUBSTRING(raw_field_value,0,15) AS field_text,
       SUBSTRING(err_reason,0,45) AS reason
FROM stl_load_errors
ORDER BY query DESC LIMIT 10;



# check locks, https://medium.com/day-i-learned/how-to-detect-locks-on-redshift-f144d23d4e09
SELECT 
  current_time, 
  c.relname, 
  l.database, 
  l.transaction, 
  l.pid, 
  a.usename, 
  l.mode, 
  l.granted
FROM pg_locks l 
JOIN pg_catalog.pg_class c ON c.oid = l.relation
JOIN pg_catalog.pg_stat_activity a ON a.procpid = l.pid
WHERE l.pid <> pg_backend_pid()
;
# identify pid that cause the problem and terminate it with
select pg_terminate_backend(21803);



# date etc
select 
sysdate::date as today,
dateadd(day, -14, sysdate)::date as twoweeksbefore,
dateadd(day,1, add_months(last_day(sysdate), -1))::date as ym1,
last_day(sysdate) as monthend,
dateadd(day,1, last_day(sysdate))::date as nextym1
;


# unload table
unload ('select * from schema.tab')
to 's3://myclust/tmp/schema.tab'
credentials 'aws_access_key_id=xxxx;aws_secret_access_key=xxxx'
delimiter as ','
gzip
escape
addquotes
null as ''
manifest
allowoverwrite
;


# create table and load from s3
DROP TABLE if exists public.energy;
CREATE TABLE public.energy (
    "rto" varchar(10) NOT NULL,
    "date" date NOT NULL,
    "hour" integer NOT NULL,
    "daenergy" double precision,
    "rtenergy" double precision
) DISTSTYLE ALL SORTKEY ("rto", "date", "hour");
COMMIT;

copy public.energy 
from 's3://xxx.csv'
credentials 'aws_access_key_id=xxx;aws_secret_access_key=xxx'
IGNOREHEADER 1
delimiter AS ','
-- gzip
REMOVEQUOTES
EXPLICIT_IDS
escape
null as ''
-- manifest
;
COMMIT;


# check connections
select * from stv_sessions;

# check table
select * from pg_tables;

#create table with distkey and sortkey
create table yinghua.taci99 (
        targetdate date,
        source integer,
        sink integer, 
        hourclass varchar(10),
        startdate date,
        aci99 float8,
        acp float8,
        PRIMARY KEY(targetdate, source, sink, hourclass, startdate))
        DISTKEY(targetdate)
        SORTKEY(targetdate, source, sink, hourclass, startdate);
COMMIT;


#check distkey sortkeys
SELECT *
FROM pg_table_def
WHERE schemaname = 'yinghua'
and tablename = 'aci99';

