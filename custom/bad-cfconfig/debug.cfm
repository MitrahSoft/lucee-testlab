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
	loop list="out.log,err.log,application.log,deploy.log,exception.log" item="logFile"{
		log = expandPath( '{lucee-server}/logs/#logFile#' );
		if ( fileExists( log ) ){
			systemOutput( "", true );
			systemOutput( "--------- #logFile#-----------", true );
			systemOutput( fileRead( log ), true );
		} else {
			systemOutput( "--------- no #logFile# [#log#]", true );
		}
	}

	param name="check_extensions" value="";

	if ( len( check_extensions ) ) {

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
					throw "Extension [#exts[ extId ].name#:#exts[extID ].version#] is installed but shoudn't be";
			} else {
				// check extension is installed and correct version
				extId = listFirst( ext, ":" );
				extVersion = listLast( ext, ":" );
				if ( ! structKeyExists(exts, extId ) ) {
					throw "Extension [#exts[ extId ].name#:#exts[ extId ].version#] should be installed";
				} else if ( extVerion != exts[ extId ].version) {
					throw "Extension [#exts[ extId ].name#] should be [#extVersion#] but is [#exts[ extId ].version#]";
				}
			}
		}
	}
	

</cfscript>