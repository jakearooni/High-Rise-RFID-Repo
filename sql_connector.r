# install.packages("RMariaDB")
# install.packages("odbc")
# install.packages("kableExtra")

# dbListConnections( dbDriver( drv = "MySQL"))
lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)

mysqlDB <- function(q, type, dbname = "") {
  
  mysql_conn <- dbConnect(
    MySQL(), 
    user = "", 
    password = "", 
    dbname = dbname, 
    host = "")
  
  if(type == "select") {
    query <- dbSendQuery(mysql_conn, q)
    result <- fetch(query, n = Inf)
    check <- dbHasCompleted(query)
    dbClearResult(query)
  }
  
  if(type == "insert") {
    query <- dbSendQuery(mysql_conn, q)
    result <- "Complete"
  }
  
  if(type == "check") {
    ## THIS DOES NOT WORK. DON'T KNOW WHY
    query <- dbSendQuery(mysql_conn, q)
    result <- dbGetRowCount(query)
    result <- fetch(query, n = Inf)
    dbClearResult(query)
    # result <- dbGetRowsAffected(query)
  }
  
  if(type == "table.insert") {
    query <- dbWriteTable(conn = mysql_conn, name = "master", value = q, 
                          append = TRUE, overwrite = FALSE, row.names = FALSE, 
                          field.types = list(import_id="int(11)", time="float(15,8)", 
                                           xpos = "float(15,8)", ypos = "float(15,8)", zpos = "float(15,8)",
                                           gpas = "float(15,8)", xvel = "float(15,8)", yvel = "float(15,8)",
                                           zvel = "float(15,8)", trajectory = "int(11)", runs = "int(11)"))
  }
  
  dbDisconnect(mysql_conn)
  
  if(exists("result") == T) { return(result) }
  
}

