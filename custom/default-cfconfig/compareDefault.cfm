<cfscript>
    default = deserializeJSON( fileRead( expandPath( "./.CFConfig-default.json" ) ) );
    empty = deserializeJSON( fileRead( expandPath('{lucee-config}.CFConfig.json') ) );

    ignore = [ "salt", "hspw" ];
    problems = 0;

    for ( cfg in default.keyList() ){
        if ( arrayContains( ignore, cfg ) ) {
            //ignore
        } else if (!structKeyExists( empty, cfg ) ){
            systemOutput("", true );
            systemOutput("#cfg# missing in empty .CFConfig.json", true );
            problems++;
        } else {
            if ( empty[ cfg ].toJson() neq default[ cfg ].toJson() ){
                systemOutput("", true );
                systemOutput("#cfg# is different!", true );
                systemOutput("#chr(9)# empty  : #empty[ cfg ].toJson()# ", true );
                systemOutput("#chr(9)# default: #default[ cfg ].toJson()# ", true );
                problems++;
            }
        }
    }

    if ( problems > 0 ){
        throw "#problems# config elements were different!";
    }
</cfscript>