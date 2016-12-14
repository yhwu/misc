%% faster load 
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET SESSION tx_isolation='READ-UNCOMMITTED';
SET sql_log_bin = 0;

load data local infile '~/rto.lmpda100M.csv' 
into table rto.lmpda
fields terminated by ','
lines terminated by '\n'
IGNORE 1 LINES;

SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;
SET sql_log_bin = 1;
