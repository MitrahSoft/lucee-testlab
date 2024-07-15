<cfscript>
	runs = server.system.environment.BENCHMARK_CYCLES ?: 400000;
	arr = [];
	
	ArraySet( arr, 1, runs, 0 );
	systemOutput( "Sleeping 5s first", true );
	sleep( 5000 ); // time to settle
	systemOutput( "Running hello world [#runs#] times", true );
	_memBefore = reportMem( "", {}, "before" );
	s = getTickCount();
	ArrayEach( arr, function( item ){
		_internalRequest(
			template: "/tests/hello-world.cfm"
		);
	}, true );

	_memStat = reportMem( "", _memBefore, "before" );

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

	struct function reportMem( string type, struct prev={}, string name="" ) {
		var qry = getMemoryUsage( type );
		var report = [];
		var used = { name: arguments.name };
		querySort(qry,"type,name");
		loop query=qry {
			if (qry.max == -1)
				var perc = 0;
			else 
				var perc = int( ( qry.used / qry.max ) * 100 );
			//if(qry.max<0 || qry.used<0 || perc<90) 	continue;
			//if(qry.max<0 || qry.used<0 || perc<90) 	continue;
			var rpt = replace(ucFirst(qry.type), '_', ' ')
				& " " & qry.name & ": " & numberFormat(perc) & "%, " & numberFormat( qry.used / 1024 / 1024 ) & " Mb";
			if ( structKeyExists( arguments.prev, qry.name ) ) {
				var change = numberFormat( (qry.used - arguments.prev[ qry.name ] ) / 1024 / 1024 );
				if ( change gt 0 ) {
					rpt &= ", (+ " & change & "Mb )";
				} else if ( change lt 0 ) {
					rpt &= ", ( " & change & "Mb )";
				}
			}
			arrayAppend( report, rpt );
			used[ qry.name ] = qry.used;
		}
		return {
			report: report,
			usage: used
		};
	}

	_logger( "Running hello world [#numberFormat( runs )#] times, took #numberFormat( time )# ms, or #numberFormat(runs/(time/1000))# per second" );
	for ( r in _memStat.report )
		_logger( r );
</cfscript>