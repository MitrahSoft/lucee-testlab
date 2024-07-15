<cfscript>
    dir = getDirectoryFromPath( getCurrentTemplatePath() ) & "artifacts";
    files = directoryList( dir );

    q = queryNew("version,java,type,runs,inspect,memory")
    for (f in files){
        systemOutput ( f, true );
        json = deserializeJson( fileRead( t ) );
        for ( r in json.data ){
            StructAppend( r, json.run );
            row = queryAddRow( q );
            QuerySetRow( q, row, r );
        }
    }

    systemOutput( serializeJSON( q, true) );
</cfscript>