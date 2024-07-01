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

	// https://github.com/MasaCMS/MasaCMS/issues/313#issuecomment-2182769621
	url.appreload = true;
	url.reload = "appreload";
	url.applydbupdates = true;
</cfscript>