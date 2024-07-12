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

	check_extensions        = server.system.environment.check_extensions ?: "";
	check_extensions_since  = server.system.environment.check_extensions_since ?: "";
	
	// don't crash on older versions
	if ( len( check_extensions_since ) ) {
		systemOutput( "", true );
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
			systemOutput( e.message, true );
			systemOutput( "checking extensions since, Lucee [#server.lucee.version#] is too old for test [#check_extensions_since#]", true );
		} 
		
	}


	if ( len( check_extensions ) ) {
		systemOutput( "", true );
		systemOutput( "checking extensions [#check_extensions#]", true );

		_exts = extensionList();
		exts = {};
		for ( e in _exts ){
			ext [ e.id ] = _exts.e;
		}

		loop list="#check_extensions#" index="ext" {
			if ( left( ext, 1 ) == "-" ) {
				// check extension isn't installed
				ext = mid( ext, 2 );
				extId = listFirst( ext, ":" );
				extVersion = listLast( ext, ":" );
				if ( structKeyExists( exts, extId ) )
					throw "ERROR: Extension [#exts[ extId ].name#:#exts[extID ].version#] is installed but shoudn't be";
				else 
					systemOutput( "Good! Extension [#extId#] isn't installed", true );
			} else {
				// check extension is installed and correct version
				extId = listFirst( ext, ":" );
				extVersion = listLast( ext, ":" );
				if ( ! structKeyExists(exts, extId ) ) {
					throw "ERROR: Extension [#exts[ extId ].name#:#exts[ extId ].version#] should be installed";
				} else if ( extVerion != exts[ extId ].version) {
					throw "ERROR: Extension [#exts[ extId ].name#] should be [#extVersion#] but is [#exts[ extId ].version#]";
				} else {
					systemOutput( "Good! Extension [#exts[ extId ].name#] version [#exts[ extId ].version#] is installed ", true );
				}
			}
		}
	}
	
	if ( len( structKeyExists( logs, "err.log" ) ) ){
		if ( len( logs["err.log"] ) ) {
			throw "err.log has errors";
		}
	}

</cfscript>