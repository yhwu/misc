#!/bin/bash

# taken from http://ojuba.org/cltb/en/articles/mdb2sqlite.html

mdb=$1
if [[ $#>1 ]]; then
    db=$2
else
    db=${mdb/\.mdb/\.sqlite3}
fi

echo input : $mdb
echo output: $db

mdb-schema "$mdb" sqlite | grep -v ^ALTER | sqlite3 "$db"
for i in $(mdb-tables "$mdb"); do 
    echo $i; 
    (echo "BEGIN TRANSACTION;";
    mdb-export -I sqlite "$mdb" $i;
    echo "END TRANSACTION;" ) | sqlite3 "$db"; 
done

exit 0
