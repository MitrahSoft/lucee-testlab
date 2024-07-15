<cfscript>
	dir = getDirectoryFromPath( getCurrentTemplatePath() ) & "artifacts";
	files = directoryList( dir );

	q = queryNew( "version,java,type,time,runs,inspect,memory,throughput" );
	for ( f in files ){
		systemOutput ( f, true );
		json = deserializeJson( fileRead( f ) );

		json.run.java = listFirst( json.run.java, "." );

		memory = 0;
		for ( m in json.memory.usage ){
			if ( isNumeric( json.memory.usage[ m ] ) )
				memory += json.memory.usage[ m ];
		}
		json.run.memory = int( memory / 1024 );

		for ( r in json.data ){
			StructAppend( r, json.run );
			r.throughput = int( json.run.runs / ( r.time / 1000 ) );
			row = queryAddRow( q );
			QuerySetRow( q, row, r );
		}
	}

	runs = q.runs;

	function _logger( string message="", boolean throw=false ){
		//systemOutput( arguments.message, true );
		if ( !FileExists( server.system.environment.GITHUB_STEP_SUMMARY ) ){
			fileWrite( server.system.environment.GITHUB_STEP_SUMMARY, "#### #server.lucee.version# ");
			//fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, server.system.environment.toJson());
		}

		if ( arguments.throw ) {
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, "> [!WARNING]" & chr(10) );
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, "> #arguments.message##chr(10)#");
			throw arguments.message;
		} else {
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, "#arguments.message##chr(10)#");
		}

	}

	function getImageBase64( img ){
		saveContent variable="local.x" {
			imageWriteToBrowser( arguments.img );
		}
		var src = listGetAt( x, 2, '"' );
		// hack suggested here https://stackoverflow.com/questions/61553399/how-can-i-save-a-valid-image-to-github-using-their-api#comment125857660_71201317
		return mid( src, len( "data:image/png;base64," ) + 1 );
	}

	```
	<cfquery name="mem_range" dbtype="query">
		select min(memory) as min, max(memory) as max
		from   q
	</cfquery>

	<cfquery name="throughput_range" dbtype="query">
		select min(throughput) as min, max(throughput) as max
		from   q
	</cfquery>

	<cfquery name="q_json_never" dbtype="query">
		select	version,java,time,memory,throughput
		from	q
		where	type = 'json'
				and inspect='never'
		order	by throughput desc
	</cfquery>

	<cfquery name="q_json_once" dbtype="query">
		select	version,java,time,memory,throughput
		from	q
		where	type = 'json' 
				and inspect='once'
		order	by throughput desc
	</cfquery>

	<cfquery name="q_hello_never" dbtype="query">
		select	version,java,time,memory,throughput
		from	q
		where	type = 'hello-world' 
				and inspect='never'
		order	by throughput desc 
	</cfquery>

	<cfquery name="q_hello_once" dbtype="query">
		select	version,java,time,memory,throughput
		from	q
		where	type = 'hello-world' 
				and inspect='once'
		order	by throughput desc 
	</cfquery>

	```

   // systemOutput( serializeJSON( q, true) );

   function dumpTable( q, title ) localmode=true {
		var hdr = [];
		var div = [];
		loop list=q.columnlist item="local.col" {
			arrayAppend( hdr, col );
			if ( col eq "memory" or col eq "time" or col eq "throughput" )
				arrayAppend( div, "---:" );
			else
				arrayAppend( div, "---" );
		}
		_logger( "" );
		_logger( "#### #arguments.title#" );
		_logger( "" );
		_logger( "|" & arrayToList( hdr, "|" ) & "|" );
		_logger( "|" & arrayToList( div, "|" ) & "|" );

		var row = [];
		loop query=q {
			loop list=q.columnlist item="local.col" {
				if ( col eq "memory" or col eq "time" or col eq "throughput" )
					arrayAppend( row, numberFormat( q [ col ] ) );
				else 
					arrayAppend( row, q [ col ] );
			}
			_logger( "|" & arrayToList( row, "|" ) & "|" );
			row = [];
		}

		_logger( "" );
	}

	_logger( "## Summary Report" );
	dumpTable( q_hello_once, "Hello World - Inspect Once" );
	dumpTable( q_hello_never, "Hello World - Inspect Never" );
	dumpTable( q_json_once, "JSON - Inspect Once" );
	dumpTable( q_json_never, "JSON - Inspect Never" );
		
</cfscript>
<!--- sigh, github doesn't suport data image urls --->

<cfloop list="never,once" item="_inspect">
	<cfchart chartheight="500" chartwidth="1024" 
			title="#UCase( _inspect )# Benchmarks - #runs# runs" format="png" name="graph"
			scaleFrom="#throughput_range.min#" scaleTo="#throughput_range.max#"> 
		<cfchartseries type="line" seriesLabel="Hello World"> 
			<cfloop query="q">
				<cfif q.type eq "hello-world" and q.inspect eq _inspect>
					<cfchartdata item="#q.version# #q.java#" value="#q.throughput#"> 
				</cfif>
			</cfloop> 
		</cfchartseries>
		<cfchartseries type="line" seriesLabel="Json"> 
			<cfloop query="q">
				<cfif q.type eq "json" and q.inspect eq _inspect>>
					<cfchartdata item="#q.version# #q.java#" value="#q.throughput#"> 
				</cfif>
			</cfloop> 
		</cfchartseries> 
	</cfchart>
	<cfscript>
		_logger( "#### Inspect #UCase( _inspect )# Benchmarks - #runs# runs" );
		_logger( "" );
		_logger( "![Inspect #UCase( _inspect )# Benchmarks](#getImageBase64( graph )#)" );
		_logger( "" );
	</cfscript>
</cfloop>

<cfchart chartheight="500" chartwidth="1024" 
		title="Memory Benchmarks - #runs# runs" format="png" name="graph"
		scaleFrom="#mem_range.min#" scaleTo="#mem_range.max#"> 
	<cfchartseries type="line" seriesLabel="Memory"> 
		<cfloop query="q">
			<cfif q.type eq "hello-world" and q.inspect eq "never">
				<cfchartdata item="#q.version# #q.java#" value="#q.memory#"> 
			</cfif>
		</cfloop> 
	</cfchartseries>
</cfchart>
<cfscript>
	_logger( "#### Memory Benchmarks - #runs# runs" );
	_logger( "" );
	_logger( "![Memory Benchmarks](#getImageBase64( graph )#)" );
	_logger( "" );
</cfscript>
