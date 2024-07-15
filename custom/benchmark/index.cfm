<cfscript>
    runs = server.system.environment.BENCHMARK_CYCLES ?: 10000;
    arr = [];
    systemOutput("Running hello world [#runs#] times", true);
    ArraySet( arr, 1, runs, 0 );
    s = getTickCount();

    ArrayEach( function( item ){
        InternalRequest(
            url: "/tests/hello-world.cfm"
        );
    }, true );

    time = getTickCount()-s;

    function _logger( string message="", boolean throw=false ){
		systemOutput( arguments.message, true );
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

    _logger( "Running hello world [#runs#] times, took #numberFormat(time)# ms, or #numberFormat(runs/(time/1000))# per second" );
</cfscript>