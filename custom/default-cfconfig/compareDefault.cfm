<cfscript>
    default = deserializeJSON( fileRead( expandPath( "./.CFConfig-default.json" ) ) );
    empty = deserializeJSON( fileRead( expandPath('{lucee-config}.CFConfig.json') ) );
    
    for ( cfc in default.keyList() ){
        if (!structKeyExists( empty, cfg ) ){
            systemOutput("", true );
            systemOutput("#cfg# missing in empty .CFConfig.json", true );
        } else {
            if ( empty[cfg].toJson() neq default[cfg].toJson() ){
                systemOutput("", true );
                systemOutput("#cfg# is different!", true );
                systemOutput("#chr(9)# empty  : #empty[cfg].toJson()# ", true );
                systemOutput("#chr(9)# default: #default[cfg].toJson()# ", true );
            }
        }
    }
</cfscript>