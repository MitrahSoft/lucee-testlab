<cfscript>
    default = deserializeJSON( fileRead( expandPath( "./.CFConfig-default.json" ) ) );
    contextFiles = directoryList( path=Expandpath( "{lucee-config}" ), recurse=true );
    cfgPAth = expandPath( '{lucee-config}.CFConfig.json' );
    if ( !fileExists( cfgPath ) ){
        for ( cf in contextFiles ) {
            systemOutput( cf, true );
        }
        log = expandPath( '{lucee-config}/logs/out.log' );
        if ( !fileExists( log ) ){
            systemOutput( "" ):
            systemOutput( "--------- out.log-----------" ):            
            systemOutput( fileRead( log ) ):
        }
        errlog = expandPath( '{lucee-config}/logs/err.log' );
        if ( !fileExists( errlog ) ){
            systemOutput( "" ):
            systemOutput( "--------- err.log-----------" ):
            systemOutput( fileRead( errlog ) ):
        }
        
        throw "missing .CFConfig.json [#cfgPath#]";
    }
    
    empty = deserializeJSON( fileRead( cfgPath ) );

    ignore = [ "salt", "hspw" ];
    problems = 0;

    for ( cfg in default.keyList() ){
        if ( arrayContains( ignore, cfg ) ) {
            //ignore
        } else if (!structKeyExists( empty, cfg ) ){
            systemOutput("", true );
            systemOutput("#cfg# missing in empty .CFConfig.json", true, true );
            problems++;
        } else if ( empty[ cfg ].toJson() neq default[ cfg ].toJson() ){
            systemOutput("", true );
            systemOutput("#cfg# is different!", true, true );
            systemOutput("#chr(9)# empty  : #empty[ cfg ].toJson()# ", true );
            systemOutput("#chr(9)# default: #default[ cfg ].toJson()# ", true );
            problems++;
        } else {
            systemOutput("#cfg# matches!", true );
        }
    }

    if ( problems > 0 ){
        throw "#problems# config elements were different!";
    } else {
        systemOutput("", true);
        systemOutput("Great! #structcount(default)-ArrayLen(ignore)# checked and matched", true);
    }
</cfscript>