<cfscript>
    q = extensionList();
    cols = replaceNoCase( q.columnList, ",unique", "" ); // cleanup reserved word
    // native engine
    q_native = QueryExecute(
        sql = "SELECT #cols# FROM q",
        options = { dbtype: 'query' }
    );
    // hsqldb engine, coz join
    q_hsqlb = QueryExecute(
        sql = "SELECT t1.name FROM q t1, q t2 WHERE t1.id = t2.id",
        options = { dbtype: 'query' }
    );
    echo( q_native.recordcount + q_hsqlb.recordcount );
</cfscript>