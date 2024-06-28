<cfscript>
    default = deserializeJSON( fileRead( expandPath( "./.CFConfig-default.json" ) ) );
    cfgPath = expandPath( '{lucee-config}.CFConfig.json' );
    if ( !fileExists( cfgPath ) ){

        admin
            action="updatePassword"
            type="server"
            oldPassword="admin"
            newPassword="admin";
        
        if ( !fileExists( cfgPath ) ){
            systemOutput( "update password via cfadmin didn't help either", true );
        
            systemOutput( "--------- .CFConfig-empty.json-----------", true );
            empty = fileRead( expandPath( "./.CFConfig-empty.json" ) );
           // systemOutput( empty, true );

            systemOutput( "", true );
            systemOutput( "ERROR: missing .CFConfig.json [#cfgPath#]", true );
            systemOutput( "", true );
            
            systemOutput( "--------- listing files under {lucee-config} -----------", true );
            contextFiles = directoryList( path=Expandpath( "{lucee-config}" ), recurse=true );
            for ( cf in contextFiles ) {
                systemOutput( cf, true );
            }
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
           // throw "missing .CFConfig.json [#cfgPath#]";
            cfgPath  = empty; // 6.1 simply updates the file at lucee.base.config
        }
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