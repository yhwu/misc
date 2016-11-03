parse_ini <- function(inifile="") {
    inilines = readLines(inifile)
    inilines = grep("^\\s+$", inilines, value=TRUE, invert = TRUE) # remove witespace lines
    inilines = inilines[sapply(inilines, nchar) > 0] # remove empty lines
    inilines = sub("\\s+$", "", inilines) # trim trailing white spaces
    inilines = sub("^\\s+", "", inilines) # trim leading white spaces
    inilines = grep("^#", inilines, value=TRUE, invert = TRUE) # remove comment lines
    lst <- split(inilines, cumsum(grepl("^\\[.*\\]$", inilines))) # split by group in [group]
    ini <- lapply(lst, function(x) { # parse the lists
        group=x[1]
        group=sub("^\\[", "", group)
        group=sub("\\]$", "", group)
        x=gsub("\\s+", "", x[-1])
        x=sub('=', '\n', x) # in case = in value
        fields=sapply(strsplit(x, '\n'), "[[", 1)
        values=sapply(strsplit(x, '\n'), "[[", 2)
        names(values)=fields
        values=c("group"=group, values)
        return( values )
    })
    names(ini) = sapply(ini, "[[", 'group') # attach group name
    return(ini)    
}


## example and tests
library("testthat")
test_that("parse_ini", {
    config = "[client]
    host=localhost
    user=userA
    password=password=A
    port = 3306
    #port=3307
    database=testdb"
    zz <- textConnection(config, "r")
    
    x = parse_ini(zz)
    expect_equal( as.character(x[["client"]]['group']),    'client')
    expect_equal( as.character(x[["client"]]['host']),     'localhost')
    expect_equal( as.character(x[["client"]]['user']),     'userA')
    expect_equal( as.character(x[["client"]]['password']), 'password=A')
    expect_equal( as.character(x[["client"]]['port']),     '3306')
    expect_equal( as.character(x[["client"]]['database']), 'testdb')
})

test_that("parse_ini", {
    config = "[client]
    host=localhost
    user=userA
    password=password=A
    port = 3306
    database=testdb"
    zz <- textConnection( c(config, sub('client', 'mysql', config)), "r")
    
    x = parse_ini(zz)
    expect_equal( as.character(x[["client"]]['group']),    'client')
    expect_equal( as.character(x[["client"]]['host']),     'localhost')
    expect_equal( as.character(x[["client"]]['user']),     'userA')
    expect_equal( as.character(x[["client"]]['password']), 'password=A')
    expect_equal( as.character(x[["client"]]['port']),     '3306')
    expect_equal( as.character(x[["client"]]['database']), 'testdb')
    expect_equal( names(x), c("client", "mysql"))
    expect_equal( x[["client"]][-1], x[["mysql"]][-1])
})

