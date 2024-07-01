<cfscript>
    if (fileExists(expandpath("/.cfconfig.json"))){
		systemOutput("importing cfconfig.json", true);
		configImport(
			type: "server",
			data: deserializeJSON(fileRead(expandpath("/.cfconfig.json"))),
			password="admin"
		);
	} else {
		systemOutput( "File not found [#expandpath("/.cfconfig.json")#]", true );
	}
   // sleep(2000);
    systemOutput(getApplicationSettings().datasources.toJson(), true);
    dbinfo type="Version" datasource="masacms" name="verify";
    systemOutput(verify.toJson(), true);
</cfscript>