aws s3 mb s3://myclust

#copy into table from s3, table must exists, have to deal with duplicates
copy schema.table 
from 's3://bucket/prefix.' 
credentials 'aws_access_key_id=xxx;aws_secret_access_key=xxx'
region 'us-east-1' 
csv gzip ignoreheader 1 emptyasnull;

#check error
select query, substring(filename,22,25) as filename,line_number as line, 
substring(colname,0,12) as column, type, position as pos, substring(raw_line,0,30) as line_text,
substring(raw_field_value,0,15) as field_text, 
substring(err_reason,0,45) as reason
from stl_load_errors 
order by query desc
limit 10;

# check connections
select * from stv_sessions;


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

