<cfscript>
    dir = getDirectoryFromPath( getCurrentTemplatePath() ) & "artifacts";
    files = directoryList( dir );

    q = queryNew("version,java,type,runs,inspect,memory")
    for (f in files){
        systemOutput ( f, true );
        json = deserializeJson( fileRead( f ) );

        memory = 0;
        for ( m in json.memory.usage ){
            if ( isNumeric( json.memory.usage[ m ] ) )
                memory += json.memory.usage[ m ];
        }
        json.run.memory = memory;

        for ( r in json.data ){
            StructAppend( r, json.run );
            row = queryAddRow( q );
            QuerySetRow( q, row, r );
        }
    }

    function _logger( string message="", boolean throw=false ){
		//systemOutput( arguments.message, true );
		if ( !FileExists( server.system.environment.GITHUB_STEP_SUMMARY ) ){
			fileWrite( server.system.environment.GITHUB_STEP_SUMMARY, "#### #server.lucee.version# ");
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, server.system.environment.toJson());
		}

		if ( arguments.throw ) {
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, "> [!WARNING]" & chr(10) );
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, "> #arguments.message##chr(10)#");
			throw arguments.message;
		} else {
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, " #arguments.message##chr(10)#");
		}

	}

    systemOutput( serializeJSON( q, true) );
</cfscript>

<cfloop list="none,once" item="_inspect">
    <cfchart chartheight="500" chartwidth="1024" title="#_inspect# Benchmarks" format="png" name="graph"> 
        <cfchartseries type="line" seriesLabel="Hello World"> 
            <cfloop query="q">
                <cfif q.type eq "hello-world" and q.inspect eq _inspect>
                    <cfchartdata item="#q.version# #q.java#" value="#q.time#"> 
                </cfif>
            </cfloop> 
        </cfchartseries>
        <cfchartseries type="line" seriesLabel="Json"> 
            <cfloop query="q">
                <cfif q.type eq "json" and q.inspect eq _inspect>>
                    <cfchartdata item="#q.version# #q.java#" value="#q.time#"> 
                </cfif>
            </cfloop> 
        </cfchartseries> 
    </cfchart>
    <cfscript>
        _logger( "![#inspect# Benchmarks](data:image/png;base64,#toBase64( graph )#)" );
    </cfscript>
</cfloop>

<!--- memory data is the same accross all runs anyway --->
<cfloop list="none" item="_inspect">
    <cfchart chartheight="500" chartwidth="1024" title="Memory Benchmarks" format="png" name="graph"> 
        <cfchartseries type="line" seriesLabel="Memory"> 
            <cfloop query="q">
                <cfif q.type eq "hello-world" and q.inspect eq _inspect>
                    <cfchartdata item="#q.version# #q.java#" value="#q.memory#"> 
                </cfif>
            </cfloop> 
        </cfchartseries>
    </cfchart>
    <cfscript>
        _logger( "!Memory Benchmarks](data:image/png;base64,#toBase64( graph )#)" );
    </cfscript>
</cfloop>