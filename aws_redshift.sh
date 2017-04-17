aws s3 mb s3://myclust

# date etc
select sysdate::date as today,
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



# check running queries
select pid, user_name, starttime, query
from stv_recents
where status='Running';

# cancel query
cancel 11475;

# check error
select query, substring(filename,22,25) as filename,line_number as line, 
substring(colname,0,12) as column, type, position as pos, substring(raw_line,0,30) as line_text,
substring(raw_field_value,0,15) as field_text, 
substring(err_reason,0,45) as reason
from stl_load_errors 
order by query desc
limit 10;

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

