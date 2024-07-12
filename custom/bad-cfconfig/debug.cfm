<cfscript>
	
	systemOutput("Hello World, Lucee Script Engine Runner, Debugger", true);
	systemOutput("#getCurrentTemplatePath()#", true);
	systemoutput("", true);
	systemoutput("--------- variables -------", true);
	loop collection=#variables# key="key" value="value"{
		systemoutput("#key#=#serializeJson(value)#", true);
	}

	systemoutput("", true);
	systemoutput("--------- System properties (lucee.*) -------", true);
	for ( p in server.system.properties ){
		if ( listFirst( p, "." ) eq "lucee" ){
			if ( p contains "password" or p contains "secret"){
				systemOutput( p & ": (not shown coz it's a password)", true);
			} else {
				systemOutput( p & ": " & server.system.properties[p], true);
			}
		}
	}

	systemoutput("", true);
	systemoutput("--------- Environment variables (lucee*) -------", true);
	for ( e in server.system.environment ){
		if ( left( e, 5 ) eq "lucee"){
			if ( e contains "password" or e contains "secret" ){
				systemOutput( e & ": (not shown coz it's a password)", true);
			} else {
				systemOutput( e & ": " & server.system.environment[e], true);
			}
		}
	}

	systemoutput("", true);
	systemoutput("--------- Installed Extensions -------", true);
	q_ext = extensionList();
	loop query="q_ext"{
		systemoutput("#q_ext.name#, #q_ext.version#", true);
	}

	systemoutput("", true);
	systemoutput("--------- Directories -------", true);
	q_ext = extensionList();
	loop list="{lucee-web},{lucee-server},{lucee-config},{temp-directory},{home-directory},{web-root-directory},{system-directory},{web-context-hash},{web-context-label}"
		item="dir" {
		systemoutput("#dir#, #expandPath(dir)#", true);
	}
	/*
	systemoutput("", true);
	systemoutput("--------- context cfcs -------", true);

	cfcs = directoryList(path=expandPath("{lucee-server}"), recurse=true, filter="*.cfc");
	for (c in cfcs){
		systemoutput(c, true);
	}
	*/

	systemoutput("", true);

	logs = {};
	loop list="out.log,err.log,application.log,deploy.log,exception.log" item="logFile"{
		log = expandPath( '{lucee-server}/logs/#logFile#' );
		if ( fileExists( log ) ){
			systemOutput( "", true );
			systemOutput( "--------- #logFile#-----------", true );
			_log = fileRead( log );
			logs [ _log ] = trim( _log );
			systemOutput( _log, true );
		} else {
			systemOutput( "--------- no #logFile# [#log#]", true );
		}
	}

	function _logger( string message="", boolean throw=false ){
		systemOutput( arguments.message, true );
		if ( !FileExists( server.system.environment.GITHUB_STEP_SUMMARY ) ){
			fileWrite( server.system.environment.GITHUB_STEP_SUMMARY,
				"#### #server.lucee.version# ", true );
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, server.system.environment.toJson());
		}

		if ( arguments.throw ) {
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, "[!WARNING]" & chr(10) );
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, " #arguments.message##chr(10)#");
			throw arguments.message;
		} else {
			fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, " #arguments.message##chr(10)#");
		}

	}

	check_extensions        = server.system.environment.check_extensions ?: "";
	check_extensions_since  = server.system.environment.check_extensions_since ?: "";
	
	// don't crash on older versions
	if ( len( check_extensions_since ) ) {
		_logger( "" );
		luceeVersion = ListToArray( server.lucee.version, "." );
		sinceVersion = ListToArray( check_extensions_since, "." );

		try {
			loop array=luceeVersion item="vv" index="i" {
				if ( i gt arrayLen( sinceVersion ) )
					break; // all good
				if ( vv lt luceeVersion[ i ] )
					throw "too old!"
			}
		} catch( e ) {
			_logger( e.message );
			_logger( "checking extensions since, Lucee [#server.lucee.version#] is too old for test [#check_extensions_since#]");
		} 
		
	}


	if ( len( check_extensions ) ) {
		//_logger( " " );
		_logger( "checking extensions [#check_extensions#]");

		_exts = extensionList();
		exts = {};
		for ( e in _exts ){
			ext [ e.id ] = e;
		}

		loop list="#check_extensions#" index="ext" {
			if ( left( ext, 1 ) == "-" ) {
				// check extension isn't installed
				ext = mid( ext, 2 );
				extId = listFirst( ext, ":" );
				extVersion = listLast( ext, ":" );
				if ( structKeyExists( exts, extId ) )
					_logger( "ERROR: Extension [#exts[ extId ].name#:#exts[extID ].version#] is installed but shoudn't be", true);
				else 
					_logger( "Good! Extension [#extId#] isn't installed");
			} else {
				// check extension is installed and correct version
				extId = listFirst( ext, ":" );
				extVersion = listLast( ext, ":" );
				if ( ! structKeyExists(exts, extId ) ) {
					_logger( "ERROR: Extension [#extId#:#extVersion#] should be installed", true);
				} else if ( extVerion != exts[ extId ].version) {
					_logger( "ERROR: Extension [#exts[ extId ].name#] should be [#extVersion#] but is [#exts[ extId ].version#]", true);
				} else {
					_logger( "Good! Extension [#exts[ extId ].name#] version [#exts[ extId ].version#] is installed ");
				}
			}
		}
	}
	
	if ( structKeyExists( logs, "err.log" ) && len( logs["err.log"] ?: "" ) ) {
		_logger( logs[ "err.log" ] , true);
	}

</cfscript>