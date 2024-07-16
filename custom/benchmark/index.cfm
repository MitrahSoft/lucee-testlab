<cfscript>
	runs = server.system.environment.BENCHMARK_CYCLES ?: 20000;
	arr = [];
	warmup = []

	results = {
		data = [],
		run = {
			version: server.lucee.version,
			java: server.java.version,
			runs: runs
		}
	};
	
	ArraySet( arr, 1, runs, 0 );
	ArraySet( warmup, 1, 100, 0 );
	
	_memBefore = reportMem( "", {}, "before", "HEAP" );	

	loop list="once,never" item="inspect" {
		configImport( {"inspectTemplate": inspect }, "server", "admin" );
		
		loop list="#application.testSuite.toList()#" item="type" {
			ArrayEach( arr, function( item ){
				_internalRequest(
					template: "/tests/#type#.cfm"
				);
			}, true );
			systemOutput( "Sleeping 2s first, after warmup", true );	
			sleep( 2000 ); // time to settle

			systemOutput( "Running #type# [#numberFormat( runs )#] times, inspect: [#inspect#]", true );
			s = getTickCount();
			ArrayEach( arr, function( item ){
				_internalRequest(
					template: "/tests/#type#.cfm"
				);
			}, true );

			time = getTickCount()-s;

			_logger( "Running #type# [#numberFormat( runs )#] times, inspect: [#inspect#] took #numberFormat( time )# ms, or #numberFormat(runs/(time/1000))# per second" );
			ArrayAppend( results.data, {
				time: time,
				inspect: inspect,
				type: type 
			});
		}
	}

	_memStat = reportMem( "", _memBefore, "before", "HEAP" );

	for ( r in _memStat.report )
		_logger( r );

	results.memory=_memStat;
	dir = getDirectoryFromPath( getCurrentTemplatePath() ) & "artifacts/";
	directoryCreate( dir );
	fileWrite( dir & server.lucee.version & "-" & server.java.version & "-results.json", results.toJson() );


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

	struct function reportMem( string type, struct prev={}, string name="", filter="" ) {
		var qry = getMemoryUsage( type );
		var report = [];
		var used = { name: arguments.name };
		querySort(qry,"type,name");
		loop query=qry {
			if ( len( arguments.filter ) and arguments.filter neq qry.type )
				continue;
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
</cfscript>