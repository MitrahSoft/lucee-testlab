<cfscript>
	paths = [ "root.test.suite" ];
	try{
		setting requesttimeout=10000;
		testRunner = New testbox.system.TestBox();
		result = testRunner.runRaw( bundles=paths );
		reporter = testRunner.buildReporter( "text" );
		try {
			report = reporter.runReport( results=result, testbox=testRunner, justReturn=true );
		} catch (e) {
			systemOutput(e, true);
		}
		failure = ( result.getTotalFail() + result.getTotalError() ) > 0;

		headline = "Lucee #server.lucee.version# / Java #server.java.version#";

		if ( structKeyExists( server.system.environment, "GITHUB_STEP_SUMMARY" ) ){
			fileWrite( server.system.environment.GITHUB_STEP_SUMMARY, "## #(failure?':x:':':heavy_check_mark:')#" & headline & chr(10) );
			//fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, report );
		} else {
			systemOutput( headline, true );
		}
		systemOutput( report, true );

		if ( failure ) {
			error = "TestBox could not successfully execute all testcases: #result.getTotalFail()# tests failed; #result.getTotalError()# tests errored.";
			if ( structKeyExists( server.system.environment, "GITHUB_STEP_SUMMARY" ) ){
				fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, chr(10) & "#### " & error );
			} else {
				systemOutput( error, true );
			}
			throw error;
		}
	}
	catch( any exception ){
		systemOutput( exception, true );
		rethrow;
	}
</cfscript>