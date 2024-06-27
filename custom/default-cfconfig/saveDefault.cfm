<cfscript>
    default = fileRead( expandPath('{lucee-config}.CFConfig.json') );
    fileWrite( expandPath("./.CFConfig-default.json"), default );

    log = expandPath( '{lucee-config}/logs/out.log' );
    if ( fileExists( log ) ){
        systemOutput( "", true );
        systemOutput( "--------- out.log-----------", true );
        systemOutput( fileRead( log ), true );
    } else {
        systemOutput( "--------- no out.log [#log#]", true );
    }
    errlog = expandPath( '{lucee-config}/logs/err.log' );
    if ( fileExists( errlog ) ){
        systemOutput( "", true );
        systemOutput( "--------- err.log-----------", true );
        systemOutput( fileRead( errlog ), true );
    } else {
        systemOutput( "--------- no err.log [#errlog#]", true );
    }

</cfscript>